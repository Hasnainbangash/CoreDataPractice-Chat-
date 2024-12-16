//
//  Message+CoreDataProperties.swift
//  CoreDataPractice(Chat)
//
//  Created by Elexoft on 16/12/2024.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var messages: String?
    @NSManaged public var userId: UUID?
    @NSManaged public var user: User?

}

extension Message : Identifiable {

}
