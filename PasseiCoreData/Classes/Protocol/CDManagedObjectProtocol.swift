//
//  CDManagedObjectProtocol.swift
//  PasseiCoreData
//
//  Created by Vagner Oliveira on 21/01/24.
//

import Foundation
import CoreData

/// Protocolo para implementação de operações básicas de um Core Data (CD) para um modelo específico.
public protocol CDManagedObjectProtocol {
    
    /// Tipo associado que representa o modelo NSManagedObject associado a este protocolo.
    associatedtype Model: NSManagedObject.Model
    
    /// Gerenciador de persistência do Core Data.
    var manager: CDPersistenceManager { get }
    
    /// Obtém um objeto do tipo Model do Core Data.
    /// - Returns: Objeto do tipo Model recuperado do Core Data, ou nil se não encontrado.
    /// - Throws: Erros relacionados à recuperação do objeto.
    func get() throws -> Model?
    
    /// Salva um objeto do tipo Model no Core Data de forma assíncrona.
    /// - Parameter model: Objeto do tipo Model a ser salvo.
    /// - Throws: Erros relacionados à operação de salvamento.
    func save(model: Model?) async throws
    
    /// Atualiza um objeto do tipo Model no Core Data com base na chave fornecida.
    /// - Parameters:
    ///   - model: Objeto do tipo Model a ser atualizado.
    ///   - keyOf: Chave para identificar a propriedade do modelo a ser atualizada.
    /// - Throws: Erros relacionados à operação de atualização.
    func update(model: Model?, keyOf: String) throws
    
    /// Exclui um objeto do tipo Model do Core Data com base na chave fornecida.
    /// - Parameters:
    ///   - model: Objeto do tipo Model a ser excluído.
    ///   - keyOf: Chave para identificar a propriedade do modelo para exclusão.
    /// - Throws: Erros relacionados à operação de exclusão.
    func delete(model: Model, keyOf: String) throws
    
    /// Verifica se um objeto do tipo Model no Core Data está expirado com base no tempo de expiração fornecido.
    /// - Parameters:
    ///   - expirationTime: Tempo de expiração em segundos.
    ///   - keyID: Identificador único associado ao objeto Model (opcional).
    /// - Returns: Valor booleano indicando se o objeto está expirado ou não.
    /// - Throws: Erros relacionados à verificação de expiração.
    func expired(expirationTime: Double, keyID: Int?) throws -> Bool
    
    /// Inicializador padrão para conformidade ao protocolo.
    init()
}


