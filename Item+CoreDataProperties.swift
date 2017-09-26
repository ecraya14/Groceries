//
//  Item+CoreDataProperties.swift
//  Groceries
//
//  Created by ecraya14 on 02/10/2016.
//  Copyright © 2016 AppFish. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var creationDate: Date?
    @NSManaged var itemName: String?
    @NSManaged var boughtItem: String?
    @NSManaged var list: List?

}
