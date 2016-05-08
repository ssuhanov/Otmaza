//
//  Otmaza+CoreDataProperties.swift
//  Otmaza
//
//  Created by Serge Sukhanov on 08.05.16.
//  Copyright © 2016 Serge Sukhanov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Otmaza {

    @NSManaged var id: NSNumber?
    @NSManaged var local: String?
    @NSManaged var text: String?

}
