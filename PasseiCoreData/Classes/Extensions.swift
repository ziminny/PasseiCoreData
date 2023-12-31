//
//  Extensions.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 15/11/23.
//

import Foundation
import CoreData

public protocol CoreDataModelProtocol {
    associatedtype Model = Codable where Model == Codable
    func getModel() throws -> Model?
}

public extension NSManagedObject {
    
    enum Keys: String {
        case uuid = "uuid"
        case data = "data"
        case timestamps = "timestamps"
    }
    
    func setValue(_ value: Any?, forKey key: Keys) {
        self.setValue(value, forKey: key.rawValue)
    }
    
    func value(forKey key: Keys) -> Any? {
        self.value(forKey: key.rawValue)
    }
    
}

extension NSManagedObject: CoreDataModelProtocol  {
    
    public typealias Model = Codable
    public func getModel() throws -> Model? {
        throw CDError.functionNotImplemented
    }
    
    public func makeModel<T:Model>(withData data: Data?, ofType type: T.Type) throws -> Model? {
        guard let data = data else {
            return nil
        }
        
        let decoder = JSONDecoder()
        
        let model = try decoder.decode(type.self, from: data)
        return model
    }
}

 




