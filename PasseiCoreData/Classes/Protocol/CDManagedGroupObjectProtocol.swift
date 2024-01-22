//
//  CDManagedGroupObjectProtocol.swift
//  PasseiCoreData
//
//  Created by Vagner Oliveira on 21/01/24.
//

import Foundation

/// Protocolo que estende o CDIMPLProtocol, fornecendo operações adicionais para lidar com grupos de objetos Core Data do tipo Model.
public protocol CDManagedGroupObjectProtocol: CDManagedObjectProtocol {
    
    /// Obtém todos os objetos do tipo Model do Core Data em um callback.
    /// - Parameter callback: Closure que recebe um array de objetos Model como parâmetro.
    /// - Throws: Erros relacionados à recuperação dos objetos.
    func getObjects(callback: @escaping ([Model]) -> Void) throws
    
    /// Salva um array de objetos do tipo Model no Core Data.
    /// - Parameter models: Array de objetos Model a serem salvos.
    /// - Throws: Erros relacionados à operação de salvamento.
    func save(models: [Model]) throws
    
    /// Exclui todos os objetos do tipo Model do Core Data com base na chave fornecida.
    /// - Parameters:
    ///   - models: Array de objetos Model a serem excluídos.
    ///   - keyOf: Chave para identificar a propriedade do modelo para exclusão.
    /// - Throws: Erros relacionados à operação de exclusão.
    func deleteAll(models: [Model], keyOf: String) throws
    
    /// Inicializador padrão para conformidade ao protocolo.
    init()
}
