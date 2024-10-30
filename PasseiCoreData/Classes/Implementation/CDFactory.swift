//
//  CDFactory.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 23/03/24.
//

import Foundation
import PasseiLogManager

public enum InstanceType {
    case Singleton
    case NewInstance
}

@propertyWrapper
public struct CDFactory<Service: CDManagedObjectProtocol> {
    
    private var service: Service?
    private var instanceType: InstanceType
    
    public init(instanceType: InstanceType = .Singleton) {
        self.instanceType = instanceType
    }
    
    public var wrappedValue: Service {
        
        mutating get {
            
            if instanceType == .NewInstance {
                service = Service()
                return service!
            }
            
            let retainInstance = RetainInstance<Service>() 
           
            if let contain = retainInstance(contains: Service.self) {
                service = contain
                return contain
            }
            
            if let retain = retainInstance(append: Service.self) {
                service = retain
                return retain
            }
            
            PLMLogger.logIt("Erro ao tentar reter ou criar uma nova instancia no wrappedValue do coredata (fatalError)")
            fatalError("Erro ao tentar reter ou criar uma nova instancia no wrappedValue do coredata (fatalError)")
            
        } set {
            service = newValue
        }
        
    }
    
} 

@dynamicCallable
fileprivate struct RetainInstance<Service: CDManagedObjectProtocol> { 
        
    func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Service.Type>) -> Service? {
        
        for (key,_) in args {
            if key == "contains" {
                return StorageInstence.shared.get(ofType: Service.self)
            }
            if key == "append" {
                let service = Service()
                StorageInstence.shared.append(service)
                return service
            }
        }
        
        return nil
    }
    
}


fileprivate final class StorageInstence: Sendable {
    
    static nonisolated(unsafe) var shared = StorageInstence()
    
    nonisolated(unsafe) private(set) var instances: [any CDManagedObjectProtocol] = []
    
    private let privateQueue = DispatchQueue(label: "com.passiOAB.CDFactory", attributes: .concurrent)
    
    func append(_ item: any CDManagedObjectProtocol) {
        privateQueue.async(flags: .barrier) {
            self.instances.append(item)
        }
    }
    
    func get<Service: CDManagedObjectProtocol>(ofType: Service.Type) -> Service? {
        return privateQueue.sync {
            return instances.first { $0 is Service } as? Service
        }
    }
}
