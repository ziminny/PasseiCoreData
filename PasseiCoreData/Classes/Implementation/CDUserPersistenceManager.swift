//
//  CDPersistenceManager.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 14/11/23.
//

import CoreData
import PasseiLogManager
@preconcurrency import CoreData.NSMergePolicy

/// Gerenciador de persistência para a entidade `CDUser`.
public struct CDPersistenceManager<Key>: Sendable where Key: Equatable {
    
    /// Controlador de persistência utilizado para interação com o Core Data.
    private let controller: CDPersistenceController
    
    /// Contêiner persistente do Core Data associado ao controlador.
    private var container: NSPersistentContainer { self.controller.container }
    
    /// Inicializa o gerenciador de persistência com um controlador específico.
    ///
    /// - Parameter controller: O controlador de persistência do Core Data a ser utilizado.
    public init(controller: CDPersistenceController) {
        self.controller = controller
    }
        
    /// Salva um objeto do tipo `NSManagedObject` no Core Data com base no modelo fornecido.
    ///
    /// - Parameters:
    ///   - model: O modelo a ser utilizado para criar o objeto do Core Data.
    ///   - coreDataModel: O tipo de objeto do Core Data a ser criado.
    ///
    /// - Throws: Erros ao criar ou salvar o objeto do Core Data.
    public func save<T: NSManagedObject>(withModel model: NSManagedObject.Model, andCoreDataType coreDataModel: T.Type) throws {
        
        let context = container.newBackgroundContext()
        let coreDataObject = T(context: context)
        
        try self.checkHasErrorAttributes(coreDataObject: coreDataObject)
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(model)
        let createDate: TimeInterval = Date().timeIntervalSince1970
        
        coreDataObject.setValue(UUID(), forKey: .uuid)
        coreDataObject.setValue(data, forKey: .data)
        coreDataObject.setValue(createDate, forKey: .timestamps)
        
        try context.save()
        
    }
    
    /// Salva vários objetos do tipo `NSManagedObject` no Core Data com base nos modelos fornecidos.
    ///
    /// - Parameters:
    ///   - models: Os modelos a serem utilizados para criar os objetos do Core Data.
    ///   - coreDataModel: O tipo de objeto do Core Data a ser criado.
    ///
    /// - Throws: Erros ao criar ou salvar os objetos do Core Data.
    public func saveMany<T: NSManagedObject>(withModel models: [NSManagedObject.Model], andCoreDataType coreDataModel: T.Type) throws {
        
        for model in models {
            let context = container.newBackgroundContext()
            let coreDataObject = T(context: context)
            
            try self.checkHasErrorAttributes(coreDataObject: coreDataObject)
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(model)
            let createDate: TimeInterval = Date().timeIntervalSince1970
            
            coreDataObject.setValue(UUID(), forKey: .uuid)
            coreDataObject.setValue(data, forKey: .data)
            coreDataObject.setValue(createDate, forKey: .timestamps)
            
            try context.save()
        }
        
    }
    
    /// Salva um objeto do tipo `NSManagedObject` no Core Data com base no modelo fornecido,
    /// substituindo objetos existentes do mesmo tipo.
    ///
    /// - Parameters:
    ///   - model: O modelo a ser utilizado para criar o objeto do Core Data.
    ///   - coreDataModel: O tipo de objeto do Core Data a ser criado.
    ///
    /// - Throws: Erros ao criar, salvar ou excluir objetos do Core Data.
    
    public func saveUnique<T: NSManagedObject>(withModel model: NSManagedObject.Model, andCoreDataType coreDataModel: T.Type) throws {
        
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType
        
        
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
            let createDate:TimeInterval = Date().timeIntervalSince1970
            
            coreDataObject.setValue(UUID(), forKey: .uuid)
            coreDataObject.setValue(data, forKey: .data)
            coreDataObject.setValue(createDate, forKey: .timestamps)
            
            try context.save()
        } catch {
            throw error
        }
        
    }
    
    /// Obtém todos os objetos do tipo `NSManagedObject` do Core Data.
    ///
    /// - Parameter type: O tipo de objeto do Core Data a ser recuperado.
    ///
    /// - Returns: Um array contendo os objetos do Core Data recuperados.
    ///
    /// - Throws: Erros ao recuperar os objetos do Core Data.
    ///
    /// - Note: Este método retorna um array opcional de objetos do tipo `T` recuperados do Core Data. Se ocorrerem erros durante a recuperação, uma exceção será lançada.
    ///
    /// - Warning: Certifique-se de que o tipo `T` é uma subclasse de `NSManagedObject` e implementa o protocolo `Codable` para que a codificação e decodificação dos dados seja realizada corretamente.
    public func getResults<T: NSManagedObject>(ofType type: T.Type) throws -> [T]? {
        
        let context = container.newBackgroundContext()
        let coreDataObject = T(context: context)
        
        try self.checkHasErrorAttributes(coreDataObject: coreDataObject)
        
        let request = type.fetchRequest()
        
        return try context.fetch(request) as? [T]
        
    }
    
    
    /// Obtém um objeto único do tipo `NSManagedObject` do Core Data.
    ///
    /// - Parameter type: O tipo de objeto do Core Data a ser recuperado.
    ///
    /// - Returns: Um objeto do Core Data recuperado, ou `nil` se nenhum objeto for encontrado.
    ///
    /// - Throws: Erros ao recuperar os objetos do Core Data.
    ///
    /// - Note: Este método retorna um objeto opcional do tipo `T` recuperado do Core Data. Se ocorrerem erros durante a recuperação, uma exceção será lançada.
    ///
    /// - Warning: Certifique-se de que o tipo `T` é uma subclasse de `NSManagedObject` e implementa o protocolo `Codable` para que a codificação e decodificação dos dados seja realizada corretamente.
    public func getUnique<T: NSManagedObject>(ofType type: T.Type) throws -> T? {
        
        let context = container.newBackgroundContext()
        let coreDataObject = T(context: context)
        
        try self.checkHasErrorAttributes(coreDataObject: coreDataObject)
        
        let request = type.fetchRequest()
        
        guard let results = try context.fetch(request) as? [T] else {
            throw CDError.getResults
        }
        
        return results.filter { $0.value(forKey: .uuid) != nil }.first
        
    }
    
    /// Obtém um objeto do tipo `NSManagedObject` do Core Data com base em um modelo específico.
    ///
    /// - Parameters:
    ///   - model: O modelo a ser utilizado como referência para a busca.
    ///   - coreDataType: O tipo de objeto do Core Data a ser recuperado.
    ///   - key: A chave que identifica o campo no modelo usado para a busca.
    ///   - callback: Um bloco de conclusão que retorna o objeto do Core Data encontrado ou `nil`.
    ///
    /// - Throws: Erros ao recuperar os objetos do Core Data.
    ///
    /// - Note: Este método utiliza um modelo `S` para realizar a busca no Core Data com base no campo identificado pela chave especificada.
    ///
    /// - Warning: Certifique-se de que o tipo `T` é uma subclasse de `NSManagedObject`, o tipo `S` implementa o protocolo `Codable`, e que o campo identificado pela chave no modelo tem uma correspondência no Core Data para que a busca seja realizada corretamente.
    public func getOne<T: NSManagedObject, S: NSManagedObject.Model>(withModel model: S, coreDataType: T.Type, keyOf key: String) async throws -> T? {
        
        let context = container.newBackgroundContext()
        
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
        
        var modelIdentifier: String? = nil
        
        let mirror = Mirror(reflecting: model)
        for case let (label?, value) in mirror.children {
            if label == key {
                modelIdentifier = "\(value)"
                break
            }
        }
        
        if let result {
            var breakFor = false
            for item in result {
                guard let data = item.value(forKey: .data) as? Data else { continue }
                
                let decoder = JSONDecoder()
                let currentData = try decoder.decode(S.self, from: data)
                
                let mirrorCurrentData = Mirror(reflecting: currentData)
                for case let (label?, value) in mirrorCurrentData.children {
                    if let modelIdentifier {
                        if label == key {
                            if modelIdentifier == "\(value)" {
                                breakFor = true
                                return item
                            }
                        }
                    }
                }
                
                if breakFor || result.isEmpty {
                    return nil
                }
            }
        }
        
        return nil
        
    }
    
    /// Exclui todos os dados de todas as entidades do Core Data.
    ///
    /// - Note: Este método percorre todas as entidades no modelo do Core Data e exclui todos os dados associados a cada entidade.
    public func deleteAllData() {
        
        let entities = container.managedObjectModel.entities
        
        for entity in entities {
            guard let entityName = entity.name else {
                continue
            }
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try container.viewContext.execute(deleteRequest)
                try container.viewContext.save()
            } catch {
                PLMLogger.logIt("Error delete all tables core data \(Self.self) \(#function) Error: \(error.localizedDescription)")
                print("Erro ao excluir dados da entidade \(entityName): \(error.localizedDescription)")
            }
        }
        
    }
    
    
    /// Atualiza um objeto do tipo `NSManagedObject` do Core Data com base em um modelo específico.
    ///
    /// - Parameters:
    ///   - model: O modelo a ser utilizado como referência para a atualização.
    ///   - coreDataType: O tipo de objeto do Core Data a ser atualizado.
    ///   - key: A chave que identifica o campo no modelo usado para a busca. O padrão é "id".
    ///
    /// - Throws: Erros ao atualizar o objeto do Core Data.
    ///
    /// - Note: Este método utiliza um modelo `S` para realizar a busca no Core Data com base no campo identificado pela chave especificada. Os objetos do Core Data serão atualizados com os dados do modelo fornecido.
    ///
    /// - Warning: Certifique-se de que o tipo `T` é uma subclasse de `NSManagedObject`, o tipo `S` implementa o protocolo `Codable`, e que o campo identificado pela chave no modelo tem uma correspondência no Core Data para que a atualização seja realizada corretamente.
    public func update<T: NSManagedObject, S: NSManagedObject.Model>(withModel model: S, coreDataType: T.Type, keyOf key: String = "id") throws {
        
        try self.deleteOrUpdate(withModel: model, coreDataType: coreDataType, keyOf: key, isUpdate: true)
        
    }

    /// Exclui um objeto do tipo `NSManagedObject` do Core Data com base em um modelo específico.
    ///
    /// - Parameters:
    ///   - model: O modelo a ser utilizado como referência para a exclusão.
    ///   - coreDataType: O tipo de objeto do Core Data a ser excluído.
    ///   - key: A chave que identifica o campo no modelo usado para a busca. O padrão é "id".
    ///
    /// - Throws: Erros ao excluir o objeto do Core Data.
    ///
    /// - Note: Este método utiliza um modelo `S` para realizar a busca no Core Data com base no campo identificado pela chave especificada. Os objetos do Core Data serão excluídos com base nos dados do modelo fornecido.
    ///
    /// - Warning: Certifique-se de que o tipo `T` é uma subclasse de `NSManagedObject`, o tipo `S` implementa o protocolo `Codable`, e que o campo identificado pela chave no modelo tem uma correspondência no Core Data para que a exclusão seja realizada corretamente.
    public func delete<T: NSManagedObject, S: NSManagedObject.Model>(withModel model: S, coreDataType: T.Type, keyOf key: String = "id") throws {
        
        try self.deleteOrUpdate(withModel: model, coreDataType: coreDataType, keyOf: key, isUpdate: false)
        
    }

    /// Exclui vários objetos do tipo `NSManagedObject` do Core Data com base em uma matriz de modelos específicos.
    ///
    /// - Parameters:
    ///   - models: A matriz de modelos a ser utilizada como referência para a exclusão.
    ///   - coreDataType: O tipo de objeto do Core Data a ser excluído.
    ///   - key: A chave que identifica o campo no modelo usado para a busca. O padrão é "id".
    ///
    /// - Throws: Erros ao excluir os objetos do Core Data.
    ///
    /// - Note: Este método utiliza modelos `S` para realizar a busca no Core Data com base no campo identificado pela chave especificada. Os objetos do Core Data serão excluídos com base nos dados dos modelos fornecidos.
    ///
    /// - Warning: Certifique-se de que o tipo `T` é uma subclasse de `NSManagedObject`, o tipo `S` implementa o protocolo `Codable`, e que o campo identificado pela chave no modelo tem uma correspondência no Core Data para que a exclusão seja realizada corretamente.
    public func deleteMany<T: NSManagedObject, S: NSManagedObject.Model>(withModel models: [S], coreDataType: T.Type, keyOf key: String = "id") throws {
        
        for model in models {
            try self.deleteSelecteds(withModel: model, coreDataType: coreDataType, keyOf: key)
        }
        
    }
    
    /// Exclui objetos do tipo `NSManagedObject` do Core Data com base em um modelo específico e uma chave de identificação.
    ///
    /// - Parameters:
    ///   - model: O modelo a ser utilizado como referência para a exclusão.
    ///   - coreDataType: O tipo de objeto do Core Data a ser excluído.
    ///   - key: A chave que identifica o campo no modelo usado para a busca. O padrão é "id".
    ///
    /// - Throws: Erros ao excluir os objetos do Core Data.
    ///
    /// - Note: Este método utiliza um modelo `S` para obter a chave de identificação e realizar a busca no Core Data. Os objetos do Core Data serão excluídos com base nos dados do modelo fornecido.
    ///
    /// - Warning: Certifique-se de que o tipo `T` é uma subclasse de `NSManagedObject`, o tipo `S` implementa o protocolo `Codable`, e que o campo identificado pela chave no modelo tem uma correspondência no Core Data para que a exclusão seja realizada corretamente.
    private func deleteSelecteds<T: NSManagedObject, S: NSManagedObject.Model>(withModel model: S, coreDataType: T.Type, keyOf key: String = "id") throws {
        
        let context = container.newBackgroundContext()
        
        let request = coreDataType.fetchRequest()
        
        let result = try context.fetch(request) as? [T]
        
        var id: Key?
        
        let mirror = Mirror(reflecting: model)
        
        for case let (label?, value) in mirror.children {
            if label == key {
                if let value = value as? Key {
                    id = value
                    break
                }
            }
        }
        
        if let result {
            for item in result {
                if let data = item.value(forKey: .data) as? Data {
                    
                    let dataModel = try JSONDecoder().decode(S.self, from: data)
                    
                    let mirror = Mirror(reflecting: dataModel)
                    for case let (label?, value) in mirror.children {
                        if label == key {
                            if let value = value as? Key {
                                if let id, id == value {
                                    context.delete(item)
                                }
                            }
                        }
                    }
                    
                }
            }
            
            try context.save()
        }
        
    }
    
    /// Exclui ou atualiza objetos do tipo `NSManagedObject` do Core Data com base em um modelo específico.
    ///
    /// - Parameters:
    ///   - model: O modelo a ser utilizado como referência para a exclusão ou atualização.
    ///   - coreDataType: O tipo de objeto do Core Data a ser afetado.
    ///   - key: A chave que identifica o campo no modelo usado para a busca.
    ///   - isUpdate: Um indicador de se a operação é uma atualização (`true`) ou uma exclusão (`false`). O padrão é `false`.
    ///
    /// - Throws: Erros ao excluir ou atualizar os objetos do Core Data.
    ///
    /// - Note: Este método utiliza um modelo `S` para realizar a busca no Core Data com base no campo identificado pela chave especificada. Se a operação for uma atualização, os objetos do Core Data serão atualizados com os dados do modelo fornecido.
    ///
    /// - Warning: Certifique-se de que o tipo `T` é uma subclasse de `NSManagedObject`, o tipo `S` implementa o protocolo `Codable`, e que o campo identificado pela chave no modelo tem uma correspondência no Core Data para que a operação seja realizada corretamente.
    private func deleteOrUpdate<T: NSManagedObject, S: NSManagedObject.Model>(withModel model: S, coreDataType: T.Type, keyOf key: String, isUpdate: Bool = false) throws {
        
        let context = container.newBackgroundContext()
        
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
        
        guard coreDataAttributes[NSManagedObject.Keys.timestamps.rawValue] != nil else {
            throw CDError.fieldTimestampsNotPresent
        }
        
        if let result {
            for item in result {
                context.delete(item)
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
    
    /// Verifica se o objeto do Core Data possui os atributos obrigatórios.
    ///
    /// - Parameter coreDataObject: O objeto do Core Data a ser verificado.
    ///
    /// - Throws: `CDError.fieldUUIDNotPresent` se o atributo UUID não estiver presente,
    ///           `CDError.fieldDataNotPresent` se o atributo de dados não estiver presente,
    ///           `CDError.fieldTimestampsNotPresent` se o atributo de timestamps não estiver presente.
    private func checkHasErrorAttributes(coreDataObject: NSManagedObject) throws {
        
        let coreDataEntityDescription = coreDataObject.entity
        let coreDataAttributes = coreDataEntityDescription.attributesByName
        
        if coreDataAttributes[NSManagedObject.Keys.uuid.rawValue] == nil {
            throw CDError.fieldUUIDNotPresent
        }
        
        if coreDataAttributes[NSManagedObject.Keys.data.rawValue] == nil {
            throw CDError.fieldDataNotPresent
        }
        
        if coreDataAttributes[NSManagedObject.Keys.timestamps.rawValue] == nil {
            throw CDError.fieldTimestampsNotPresent
        }
        
    }

}
