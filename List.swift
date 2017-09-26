//
//  List.swift
//  Groceries
//
//  Created by ecraya14 on 27/09/2016.
//  Copyright © 2016 AppFish. All rights reserved.
//

import Foundation
import CoreData


class List: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    convenience init(name: String, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "List", in: context) {
            
            self.init(entity: ent, insertInto: context)
            self.name = name
            self.creationDate = Date()
        } else {
            fatalError("Unable to find entity name")
        }
    }

    
    var dateAge : String {
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
