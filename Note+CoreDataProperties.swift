//
//  Note+CoreDataProperties.swift
//  Notes
//
//  Created by Ольга Егорова on 25.12.2022.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var title: String?
    @NSManaged public var text: NSMutableAttributedString?
    @NSManaged public var dateOfCreation: Date?
    @NSManaged public var dateOfLastCorrection: Date?
    @NSManaged public var favorites: Bool

}


