//
//  User+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Khánh on 30/04/2021.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var gender: Bool

}

extension User : Identifiable {

}
