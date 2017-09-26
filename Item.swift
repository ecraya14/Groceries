//
//  Item.swift
//  Groceries
//
//  Created by ecraya14 on 27/09/2016.
//  Copyright © 2016 AppFish. All rights reserved.
//

import Foundation
import CoreData


class Item: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    convenience init(itemName: String, boughtItem: String?, context: NSManagedObjectContext) {
        //The object EntityDescription has access to all info provided in 
        //the Entity part of the model
        if let ent = NSEntityDescription.entity(forEntityName: "Item", in: context) {
            self.init(entity: ent, insertInto: context)
            self.itemName = itemName
            self.boughtItem = boughtItem
            self.creationDate = Date()
        } else {
            fatalError("Unable to find entity name")
        }
    }
    
    
    var age : String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .short
            dateFormatter.doesRelativeDateFormatting = true
            dateFormatter.locale = Locale.current
            return dateFormatter.string(from: creationDate! as Date)
        }
    }

}
