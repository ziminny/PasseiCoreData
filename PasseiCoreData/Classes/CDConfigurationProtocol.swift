//
//  CDConfigurationProtocol.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 03/11/23.
//

import Foundation
import CoreData
import PasseiFake

public protocol CDConfigurationProtocol {
    var  dbName: String { get }
    func generateFakeModelInMemory(fake: FakeRecords,context: NSManagedObjectContext) throws
}
