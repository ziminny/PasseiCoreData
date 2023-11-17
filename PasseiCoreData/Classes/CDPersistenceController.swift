//
//  Persistence.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 02/06/23.
//

import CoreData
import PasseiLogManager
import PasseiFake

open class CDPersistenceController {
    
    public let configuration:CDConfigurationProtocol

    public let container: NSPersistentContainer
    
    public let fakeRecords = FakeRecords()
    
    open class func preview(withConfiguration configuration:CDConfigurationProtocol) -> CDPersistenceController   {
        let result = CDPersistenceController(withConfiguration: configuration, inMemory: true)
        let viewContext = result.container.viewContext
 
        do {
            try result.configuration.generateFakeModelInMemory(fake: result.fakeRecords, context: viewContext)
            try viewContext.save()
        } catch {
            let error = error as NSError
            print("Core data preview error: \(error)")
            LogManager.dispachLog("Error try configuration core data preview \(error.localizedDescription)")
        }
        
        return result
    } 

    public init(withConfiguration configuration:CDConfigurationProtocol, inMemory: Bool = false) {
        self.configuration = configuration
        container = NSPersistentContainer(name:configuration.dbName)
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
     
            if let error = error as NSError? {
                    print("Core data error: \(error)")
                LogManager.dispachLog("Error try configuration core data \(error.localizedDescription)")
            }
            print("Core data load")
        })
    }
    
}
