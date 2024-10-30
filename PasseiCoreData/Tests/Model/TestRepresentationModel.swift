//
//  TestRepresentationModel.swift
//  AppAuth
//
//  Created by vagner reis on 05/10/24.
//

import Foundation

struct TestRepresentationModel: Codable, Sendable, Equatable {
    let id: PrimaryKey
    let name: String
    let description: String
    let matterId: PrimaryKey
    
    static func createOne() -> Self {
        TestRepresentationModel(id: 10, name: "name", description: "description", matterId: 20)
    }
    
    static func deleteOne() -> Self {
        TestRepresentationModel(id: 30, name: "name3", description: "description3", matterId: 70)
    }
    
    static func createMany() -> [Self] {
        [
            TestRepresentationModel(id: 10, name: "name",  description: "description",  matterId: 20),
            TestRepresentationModel(id: 20, name: "name2", description: "description2", matterId: 60),
            TestRepresentationModel(id: 30, name: "name3", description: "description3", matterId: 70),
            TestRepresentationModel(id: 40, name: "name4", description: "description4", matterId: 80),
            TestRepresentationModel(id: 50, name: "name5", description: "description5", matterId: 90)
        ]
    }
}
