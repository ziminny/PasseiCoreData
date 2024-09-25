//
//  CDConfigurationProtocol.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 03/11/23.
//

import Foundation
import CoreData
import PasseiFake

/// Protocolo para configurar o Core Data.
public protocol CDConfigurationProtocol where Self: Sendable {

    /// O nome do banco de dados a ser utilizado.
    var dbName: String { get }

    /// Gera dados falsos no contexto de Core Data em memória.
    ///
    /// - Parameters:
    ///   - fake: Um objeto contendo registros falsos.
    ///   - context: O contexto de Core Data no qual os dados falsos serão gerados.
    ///
    /// - Throws: Uma exceção se ocorrer um erro durante a geração dos dados falsos.
    func generateFakeModelInMemory(fake: FakeRecords, context: NSManagedObjectContext) throws
}
