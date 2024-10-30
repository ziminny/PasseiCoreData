//
//  Persistence.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 02/06/23.
//

import CoreData
import PasseiLogManager
@preconcurrency import PasseiFake

/// Controlador de persistência para interação com o Core Data.
open class CDPersistenceController: @unchecked Sendable {
    
    /// A configuração do Core Data associada ao controlador.
    public let configuration: CDConfigurationProtocol
    
    /// O contêiner persistente do Core Data.
    public let container: NSPersistentContainer
    
    /// Conjunto de registros falsos usado para visualização de prévia.
    public let fakeRecords = FakeRecords()
    
    /// Cria uma instância do controlador para visualização de prévia.
    ///
    /// - Parameter configuration: A configuração do Core Data a ser utilizada.
    /// - Returns: Uma instância do controlador configurada para visualização de prévia.
    public static func preview(withConfiguration configuration: CDConfigurationProtocol) -> CDPersistenceController   {
        let result = CDPersistenceController(withConfiguration: configuration, inMemory: true)
        let viewContext = result.container.viewContext
        
        do {
            try result.configuration.generateFakeModelInMemory(fake: result.fakeRecords, context: viewContext)
            try viewContext.save()
        } catch {
            let error = error as NSError
            print("Core data preview error: \(error)")
            PLMLogger.logIt("Error try configuring Core Data preview: \(error.localizedDescription)")
        }
        
        return result
    }
    
    /// Inicializa o controlador de persistência do Core Data.
    ///
    /// - Parameters:
    ///   - configuration: A configuração do Core Data a ser utilizada.
    ///   - inMemory: Indica se deve ser utilizado armazenamento em memória.
    public init(withConfiguration configuration: CDConfigurationProtocol, inMemory: Bool = false, container: NSPersistentContainer? = nil) {
        self.configuration = configuration
        
        if let container {
            self.container = container
        } else {
            self.container = NSPersistentContainer(name: configuration.dbName)
        }
        
        if inMemory {
            self.container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        self.container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                print("Core data error: \(error)")
                PLMLogger.logIt("Error trying to configure Core Data: \(error.localizedDescription)")
            }
            print("Core data loaded")
        })
    }
}

