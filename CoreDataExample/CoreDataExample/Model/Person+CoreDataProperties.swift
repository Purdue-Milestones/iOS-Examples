//
//  Person+CoreDataProperties.swift
//  CoreDataExample
//
//  Created by Carolina Solís on 10/14/22.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var age: Int64
    @NSManaged public var name: String?
    @NSManaged public var gender: String?

}

extension Person : Identifiable {

}
