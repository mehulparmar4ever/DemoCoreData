//
//  Event+CoreDataProperties.swift
//  
//
//  Created by Sooryen on 1/29/18.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var eventDateTime: NSDate?
    @NSManaged public var eventDescription: String?
    @NSManaged public var eventTitle: String?
    @NSManaged public var eventuid: String?
    @NSManaged public var eventVenue: String?

}
