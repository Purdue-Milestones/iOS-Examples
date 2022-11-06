//
//  HRValue+CoreDataProperties.swift
//  
//
//  Created by Carolina Solís on 10/24/22.
//
//

import Foundation
import CoreData


extension HRValue {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HRValue> {
        return NSFetchRequest<HRValue>(entityName: "HRValue")
    }

    @NSManaged public var datesaved: String?
    @NSManaged public var heartrate: String?

}
