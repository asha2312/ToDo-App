//
//  CodingTaskInfoKey.swift
//  AshaSharm-ToDoApp
//
//  Created by Asha on 24/09/22.
//

import Foundation

public extension CodingUserInfoKey {
    // Helper property to retrieve the Core Data managed object context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
