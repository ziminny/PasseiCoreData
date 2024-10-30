//
//  TestCoreDataModel.swift
//  PasseiCoreData
//
//  Created by vagner reis on 05/10/24.
//

import Foundation
import CoreData
import PasseiCoreData
import PasseiFake

class TestCoreDataModel: NSManagedObject {
    
    typealias Model = TestRepresentationModel
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestCoreDataModel> {
        return NSFetchRequest<TestCoreDataModel>(entityName: "\(TestCoreDataModel.self)")
    }

    @NSManaged public var data: Data?
    @NSManaged public var timestamps: Double
    @NSManaged public var uuid: UUID?
    
    func getModel() throws -> Model? {
        return try makeModel(withData: self.data, ofType: Model.self) as? Model
    }
}

struct OABCoreDataConfiguration: CDConfigurationProtocol, Sendable {
    var dbName: String {"PasseiOAB"}
    func generateFakeModelInMemory(fake: FakeRecords, context: NSManagedObjectContext) throws { }
}

