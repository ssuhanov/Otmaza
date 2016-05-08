//
//  CoreDataEngine.swift
//  Otmaza
//
//  Created by Serge Sukhanov on 08.05.16.
//  Copyright © 2016 Serge Sukhanov. All rights reserved.
//

import Foundation
import CoreData

class CoreDataEngine {
    
    var moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    
    static let sharedInstance = CoreDataEngine()
    private init() {
        moc = CoreDataManager.sharedInstance.managedObjectContext
    }
    
    func createOtmaza(otmazaModel: OtmazaModel) -> Bool {
        let entityDescription = NSEntityDescription.entityForName("Otmaza", inManagedObjectContext: moc)
        let otmaza = Otmaza(entity: entityDescription!, insertIntoManagedObjectContext: moc)
        
        otmaza.setValue(otmazaModel.id, forKey: "id")
        otmaza.setValue(otmazaModel.text, forKey: "text")
        otmaza.setValue(otmazaModel.local, forKey: "local")
        
        do {
            try moc.save()
            return true
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
        return false
    }
    
    func checkOtmaza(id: NSNumber, local: String) -> Bool {
        let entityDescription = NSEntityDescription.entityForName("Otmaza", inManagedObjectContext: moc)
        let fetchRequest = NSFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND local == %@", id, local)
        fetchRequest.entity = entityDescription
        
        do {
            let results = try moc.executeFetchRequest(fetchRequest)
            if results.count == 0 {
                return false
            } else {
                return true
            }
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
        return false
    }
    
    func getOtmazasCount(local: String) -> UInt32 {
        let entityDescription = NSEntityDescription.entityForName("Otmaza", inManagedObjectContext: moc)
        let fetchRequest = NSFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "local == %@", local)
        fetchRequest.entity = entityDescription
        
        do {
            let results = try moc.executeFetchRequest(fetchRequest)
            return UInt32(results.count)
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
        return 0
    }
    
    func getOtmaza(index: Int, local: String) -> OtmazaModel? {
        let entityDescription = NSEntityDescription.entityForName("Otmaza", inManagedObjectContext: moc)
        let fetchRequest = NSFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "local == %@", local)
        fetchRequest.entity = entityDescription
        
        do {
            let results = try moc.executeFetchRequest(fetchRequest)
            let otmazas = results as! [Otmaza]
            if otmazas.count > index {
                return OtmazaModel(otmaza: otmazas[index])
            } else {
                return nil
            }
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func updateOtmaza(otmazaModel: OtmazaModel) -> Bool {
        let entityDescription = NSEntityDescription.entityForName("Otmaza", inManagedObjectContext: moc)
        let fetchRequest = NSFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", otmazaModel.id)
        fetchRequest.entity = entityDescription
        
        do {
            let results = try moc.executeFetchRequest(fetchRequest)
            let otmazas = results as! [Otmaza]
            if otmazas.count > 0 {
                let otmaza = otmazas[0]
                otmaza.setValue(otmazaModel.id, forKey: "id")
                otmaza.setValue(otmazaModel.text, forKey: "text")
                otmaza.setValue(otmazaModel.local, forKey: "local")
                
                do {
                    try moc.save()
                    return true
                } catch let error as NSError {
                    print("Unresolved error \(error), \(error.userInfo)")
                }
                return false
            } else {
                return false
            }
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
        return false
    }
    
}
