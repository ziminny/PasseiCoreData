//
//  CDUserPersistenceManager.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 14/11/23.
//

import Foundation
import CoreData
import UIKit

public class CDUserPersistenceManager {
    
    private let controller:CDPersistenceController
    private var container:NSPersistentContainer { self.controller.container }
    
    public init(controller:CDPersistenceController) {
        self.controller = controller
    }
    
    private func checkHasErrorAttributes(coreDataObject:NSManagedObject) throws {
        let coreDataEntityDescription = coreDataObject.entity
        let coreDataAttributes = coreDataEntityDescription.attributesByName
        
        if coreDataAttributes[NSManagedObject.Keys.uuid.rawValue] == nil {
            throw CDError.fieldUUIDNotPresent
        }
        
        if coreDataAttributes[NSManagedObject.Keys.data.rawValue] == nil {
            throw CDError.fieldDataNotPresent
        }
    }
    
    public func save<T: NSManagedObject>(withModel model: NSManagedObject.Model, andCoreDataType coreDataModel: T.Type) async throws {
        
        try await container.performBackgroundTask { context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            let coreDataObject = T(context: context)
            
            try self.checkHasErrorAttributes(coreDataObject: coreDataObject)
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(model)
            
            coreDataObject.setValue(UUID(), forKey: .uuid)
            coreDataObject.setValue(data, forKey: .data)
            
            try context.save()
        }
    }
    
    public func saveUnique<T: NSManagedObject>(withModel model: NSManagedObject.Model, andCoreDataType coreDataModel: T.Type) async throws {
        try await container.performBackgroundTask { context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

    
            let request = coreDataModel.fetchRequest()
            if let results = try context.fetch(request) as? [T], !results.isEmpty {
              
                for result in results {
                    context.delete(result)
                }
            }

            
            let coreDataObject = T(context: context)
            
            try self.checkHasErrorAttributes(coreDataObject: coreDataObject)

            do {
      
                let encoder = JSONEncoder()
                let data = try encoder.encode(model)

                coreDataObject.setValue(UUID(), forKey: .uuid)
                coreDataObject.setValue(data, forKey: .data)

               
                try context.save()
            } catch {
                
                throw error
            }
        }
    }

    
    
    public func getResults<T:NSManagedObject>(ofType type:T.Type,callback:@escaping ([T]?) -> Void) async throws {
        
        try await container.performBackgroundTask { context in
            
            let coreDataObject = T(context: context)
            
            try self.checkHasErrorAttributes(coreDataObject: coreDataObject)
            
            let request = type.fetchRequest()
            
            let result = try context.fetch(request) as? [T]
            
            callback(result)
        }
        
    }
    
    public func getUnique<T:NSManagedObject>(ofType type:T.Type,callback:@escaping (T?) -> Void) async throws {
        
        try await container.performBackgroundTask { context in
            
            let coreDataObject = T(context: context)
            
            try self.checkHasErrorAttributes(coreDataObject: coreDataObject)
            
            let request = type.fetchRequest()
            
            guard let result = try context.fetch(request) as? [T] else {
                callback(nil)
                throw CDError.getResults
            }
            
            callback(result.first)
        }
        
    }
    
    public func getOne<T:NSManagedObject,S:NSManagedObject.Model>(withModel model:S, savedModelType:S.Type,coreDataType:T.Type,keyOf key:String,callback: @escaping (T?) -> Void) async throws  {
        
        try await container.performBackgroundTask { context in
            
            let coreDataObject = T(context: context)
            
            let request = coreDataType.fetchRequest()
            
            let result = try context.fetch(request) as? [T]
            
            let coreDataEntityDescription = coreDataObject.entity
            let coreDataAttributes = coreDataEntityDescription.attributesByName
            
            guard coreDataAttributes[NSManagedObject.Keys.uuid.rawValue] != nil else {
                throw CDError.fieldUUIDNotPresent
            }
            
            guard coreDataAttributes[NSManagedObject.Keys.data.rawValue] != nil else {
                throw CDError.fieldDataNotPresent
            }
            
            var modelIdentifier:String? = nil
            
            let mirror = Mirror(reflecting: model)
            for case let (label?,value) in mirror.children {
                if label == key {
                    modelIdentifier = "\(value)"
                    break;
                }
            }
            
            if let result {
                var breakFor = false
                for item in result {
                    guard let data = item.value(forKey:.data) as? Data else { continue }
                    
                    let decoder = JSONDecoder()
                    let currentData = try decoder.decode(savedModelType.self, from: data)
                    
                    let mirrorCurrentData = Mirror(reflecting: currentData)
                    for case let (label?,value) in mirrorCurrentData.children {
                        if let modelIdentifier {
                            if label == key {
                                if modelIdentifier == "\(value)" {
                                    callback(item)
                                    breakFor = true
                                    return
                                }
                            }
                            
                        }
                    }
                    
                    if breakFor || result.isEmpty {
                        callback(nil)
                        return
                    }
                }
            }
            
            callback(nil)
        }
        
    }
    
    private func deleteOrUpdate<T:NSManagedObject,S:NSManagedObject.Model>(withModel model:S, savedModelType:S.Type,coreDataType:T.Type,keyOf key:String,isUpdate:Bool = false) async throws  {
        try await container.performBackgroundTask { context in
            
            let coreDataObject = T(context: context)
            
            let request = coreDataType.fetchRequest()
            
            let result = try context.fetch(request) as? [T]
            
            let coreDataEntityDescription = coreDataObject.entity
            let coreDataAttributes = coreDataEntityDescription.attributesByName
            
            guard coreDataAttributes[NSManagedObject.Keys.uuid.rawValue] != nil else {
                throw CDError.fieldUUIDNotPresent
            }
            
            guard coreDataAttributes[NSManagedObject.Keys.data.rawValue] != nil else {
                throw CDError.fieldDataNotPresent
            }
            
            var modelIdentifier:String? = nil
            
            let mirror = Mirror(reflecting: model)
            for case let (label?,value) in mirror.children {
                if label == key {
                    modelIdentifier = "\(value)"
                    break;
                }
            }
            
            if let result {
                for item in result {
                    guard let data = item.value(forKey:.data) as? Data else { continue }
                    
                    let decoder = JSONDecoder()
                    let currentData = try decoder.decode(savedModelType.self, from: data)
                    
                    let mirrorCurrentData = Mirror(reflecting: currentData)
                    for case let (label?,value) in mirrorCurrentData.children {
                        if let modelIdentifier {
                            if label == key {
                                if modelIdentifier == "\(value)" {
                                    context.delete(item)
                                    break
                                }
                            }
                            
                        }
                    }
                }
                
                if isUpdate {
                    let encoder = JSONEncoder()
                    let modelData = try encoder.encode(model)
                    
                    coreDataObject.setValue(UUID(), forKey: .uuid)
                    coreDataObject.setValue(modelData, forKey: .data)
                }
                
                try context.save()
            }
        }
    }
    
    public func update<T:NSManagedObject,S:NSManagedObject.Model>(withModel model:S, savedModelType:S.Type,coreDataType:T.Type,keyOf key:String = "id") async throws  {
        try await self.deleteOrUpdate(withModel: model, savedModelType: savedModelType, coreDataType: coreDataType,keyOf:key,isUpdate: true)
    }
    
    public func delete<T:NSManagedObject,S:NSManagedObject.Model>(withModel model:S, savedModelType:S.Type,coreDataType:T.Type,keyOf key:String = "id") async throws  {
        try await self.deleteOrUpdate(withModel: model, savedModelType: savedModelType, coreDataType: coreDataType,keyOf:key,isUpdate: false)
    }
    
}








