//
//  CDPersistentController+Memory.swift
//  AppAuth
//
//  Created by vagner reis on 05/10/24.
//

import Foundation
import PasseiCoreData
import CoreData

extension CDPersistenceController {
    static func createInMemoryPersistentContainer<Entity: NSManagedObject>(of entity: Entity.Type) -> NSPersistentContainer {
        // Criar o NSManagedObjectModel programaticamente
        let model = NSManagedObjectModel()

        // Descrição da entidade Submatter
        let submatterEntity = NSEntityDescription()
        submatterEntity.name = "\(Entity.self)"
        submatterEntity.managedObjectClassName = NSStringFromClass(Entity.self)

        // Definir atributos para a entidade
        let uuidAttribute = NSAttributeDescription()
        uuidAttribute.name = "uuid"
        uuidAttribute.attributeType = .UUIDAttributeType
        uuidAttribute.isOptional = true
        
        let dataAttribute = NSAttributeDescription()
        dataAttribute.name = "data"
        dataAttribute.attributeType = .binaryDataAttributeType
        dataAttribute.isOptional = true
        
        let timestampsAttribute = NSAttributeDescription()
        timestampsAttribute.name = "timestamps"
        timestampsAttribute.attributeType = .doubleAttributeType

        submatterEntity.properties = [uuidAttribute, dataAttribute, timestampsAttribute]

        // Adicionar a entidade ao modelo
        model.entities = [submatterEntity]

        // Criar o NSPersistentContainer em memória com o modelo
        let container = NSPersistentContainer(name: "Test\(Entity.self)", managedObjectModel: model)

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Error setting up Core Data stack: \(error)")
            }
        }

        return container
    }
}
