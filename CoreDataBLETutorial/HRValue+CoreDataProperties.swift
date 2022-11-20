//
//  HRValue+CoreDataProperties.swift
//  
//
//  Created by Carolina Solís on 11/7/22.
//
//

import Foundation
import CoreData


extension HRValue {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HRValue> {
        return NSFetchRequest<HRValue>(entityName: "HRValue")
    }

    @NSManaged public var heartrate: String?
    @NSManaged public var datesaved: String?

}
