import XCTest
import CoreData
import PasseiCoreData
import PasseiFake

typealias PrimaryKey = Int

class Tests: XCTestCase {
    
    var persistenceController: CDPersistenceController!
    var manager: CDPersistentStore<PrimaryKey>!
    
    override func setUpWithError() throws {
        // Configura o container Core Data mockado
        persistenceController = CDPersistenceController(withConfiguration: OABCoreDataConfiguration(), container: CDPersistenceController.createInMemoryPersistentContainer(of: TestCoreDataModel.self))
        manager = CDPersistentStore(controller: persistenceController)

    }
    
    override func tearDownWithError() throws {

    }
    
    func testCoreDataModelEncodingAndDecoding() throws {
        
        try? manager.save(withModel: TestRepresentationModel.createOne(), andCoreDataType: TestCoreDataModel.self)
        
        let results = try manager.getResults(ofType: TestCoreDataModel.self)
        
        XCTAssertEqual(results?.count, 1)
        
        // Testar a decodificação do modelo
        let decodedModel = try? results?.first?.getModel()
        XCTAssertEqual(decodedModel?.id, TestRepresentationModel.createOne().id)
        XCTAssertEqual(decodedModel?.name, TestRepresentationModel.createOne().name)
        XCTAssertEqual(decodedModel?.description, TestRepresentationModel.createOne().description)
    }
    
    func testCoreDataModelSaveMany() throws {
        
        try? manager.saveMany(withModel: TestRepresentationModel.createMany(), andCoreDataType: TestCoreDataModel.self)
        
        let results = try manager.getResults(ofType: TestCoreDataModel.self)
        
        XCTAssertEqual(results?.count, TestRepresentationModel.createMany().count)
    }
    
    func testCoreDataModelSaveUnique() throws {
        
        try? manager.saveMany(withModel: TestRepresentationModel.createMany(), andCoreDataType: TestCoreDataModel.self)
        try? manager.saveUnique(withModel: TestRepresentationModel.createOne(), andCoreDataType: TestCoreDataModel.self)
        
        let results = try manager.getResults(ofType: TestCoreDataModel.self)
        
        XCTAssertEqual(results?.count, 1)
    }
    
    func testCoreDataModelDeleteAll() throws {
        
        try? manager.saveMany(withModel: TestRepresentationModel.createMany(), andCoreDataType: TestCoreDataModel.self)
        try? manager.delete(withModel: TestRepresentationModel.deleteOne(), coreDataType: TestCoreDataModel.self)
        
        let results = try manager.getResults(ofType: TestCoreDataModel.self)
        
        XCTAssertEqual(results?.count, 0)
    }
    
    func testCoreDataModelDeleteQuery() throws {
        
        try? manager.saveMany(withModel: TestRepresentationModel.createMany(), andCoreDataType: TestCoreDataModel.self)
        try? manager.deleteMany(withModel: [TestRepresentationModel.deleteOne()], coreDataType: TestCoreDataModel.self)
        
        let results = try manager.getResults(ofType: TestCoreDataModel.self)
        
        XCTAssertEqual(results?.count, 4)
    }
    
    func testCoreDataModelGetOne() throws {
        
        try? manager.saveMany(withModel: TestRepresentationModel.createMany(), andCoreDataType: TestCoreDataModel.self) 
        
        let result = try? manager.getOne(withModel: TestRepresentationModel.createOne(), coreDataType: TestCoreDataModel.self, keyOf: "id")
        let model = try? result?.getModel()
        
        XCTAssertEqual(model, TestRepresentationModel.createOne())
    }
}

