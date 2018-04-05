//
//  CoreDataManager.swift
//  UrlChecker
//
//  Created by Sygnoos9 on 4/6/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    class func saveObject(urlAddress: String) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "UrlManagedModel", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(urlAddress, forKey: "urlAddress")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func removeObject(model: UrlManagedModel) -> Bool {
        let context = getContext()
        context.delete(model)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }

    class func fetchObjects() -> [UrlManagedModel] {
        let context = getContext()
        var objects: [UrlManagedModel] = []
        do {
            let managedObjects = try context.fetch(UrlManagedModel.fetchRequest()) as? [UrlManagedModel]
            if let managedObjects = managedObjects {
                objects = managedObjects
            }
            return objects
        } catch {
            return objects
        }
    }
}
