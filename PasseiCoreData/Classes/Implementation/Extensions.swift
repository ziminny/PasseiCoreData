//
//  Extensions.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 15/11/23.
//

import Foundation
import CoreData

/// Protocolo que define métodos para interação com objetos do Core Data.
public protocol CoreDataModelProtocol {

    /// Tipo associado ao protocolo, conforme conformidade a `Codable`.
    associatedtype Model = Codable where Model == Codable

    /// Obtém o modelo associado ao objeto do Core Data.
    ///
    /// - Returns: O modelo associado ao objeto do Core Data.
    ///
    /// - Throws: `CDError.functionNotImplemented` se o método não estiver implementado.
    func getModel() throws -> Model?
}

/// Extensão para `NSManagedObject` que fornece funcionalidades adicionais relacionadas ao Core Data.
public extension NSManagedObject {
    
    /// Enumeração que define chaves associadas aos atributos do Core Data.
    enum Keys: String {
        case uuid = "uuid"
        case data = "data"
        case timestamps = "timestamps"
    }
    
    /// Define o valor para a chave especificada.
    ///
    /// - Parameters:
    ///   - value: O valor a ser definido.
    ///   - key: A chave para a qual o valor será definido.
    func setValue(_ value: Any?, forKey key: Keys) {
        self.setValue(value, forKey: key.rawValue)
    }
    
    /// Obtém o valor para a chave especificada.
    ///
    /// - Parameter key: A chave para a qual o valor será obtido.
    /// - Returns: O valor associado à chave especificada.
    func value(forKey key: Keys) -> Any? {
        self.value(forKey: key.rawValue)
    }
}

extension NSManagedObject: CoreDataModelProtocol  {
    
    /// Tipo associado ao protocolo, conforme conformidade a `Codable`.
    public typealias Model = Codable
    
    /// Obtém o modelo associado ao objeto do Core Data.
    ///
    /// - Returns: O modelo associado ao objeto do Core Data.
    ///
    /// - Throws: `CDError.functionNotImplemented` se o método não estiver implementado.
    public func getModel() throws -> Model? {
        throw CDError.functionNotImplemented(String(describing: Model.self))
    }
    
    /// Cria um modelo a partir dos dados fornecidos.
    ///
    /// - Parameters:
    ///   - data: Os dados a serem utilizados para criar o modelo.
    ///   - type: O tipo do modelo a ser criado.
    ///
    /// - Returns: O modelo criado a partir dos dados.
    ///
    /// - Throws: Erros ao decodificar o modelo a partir dos dados.
    public func makeModel<T: Model>(withData data: Data?, ofType type: T.Type) throws -> Model? {
        guard let data = data else {
            return nil
        }
        
        let decoder = JSONDecoder()
        
        let model = try decoder.decode(type.self, from: data)
        return model
    }
}


