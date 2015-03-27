//
//  DatabaseManager.swift
//  DoeNota
//
//  Created by Isa Sophia on 2/17/15.
//  Copyright (c) 2015 Isadora Sophia. All rights reserved.
//

import UIKit
import CoreData

@objc(Task)

class DatabaseManager: NSObject {
    class var sharedInstance: DatabaseManager {
        struct Static {
            static var instance: DatabaseManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = DatabaseManager()
        }
        
        return Static.instance!
    }
    
    var notas = [NSManagedObject]()
    var preferences = [NSManagedObject]()
    
    func getSet () {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        var error: NSError?
        
        var fetchRequest = NSFetchRequest (entityName: "Nota")
        var fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]!
        
        if let results = fetchedResults {
            self.notas = results
        }
        
        fetchRequest = NSFetchRequest (entityName: "Preferences")
        fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            preferences = results
        }
        
        if (preferences.isEmpty) {
            let entity =  NSEntityDescription.entityForName("Preferences", inManagedObjectContext: managedContext)
            let uniqueID = UIDevice.currentDevice().identifierForVendor!.UUIDString
            
            let preference = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            preference.setValue(true, forKey: "hability3G")
            preference.setValue(1, forKey: "institution")
            preference.setValue(0, forKey: "numberPhotos")
            preference.setValue(uniqueID, forKey: "userID")
            
            managedContext.save(&error)
            
            preferences.append(preference)
        }
    }
    
    // Regarging notas database
    func savePhoto(image: NSData, institution: Int, user: NSString, id: NSString) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Nota", inManagedObjectContext: managedContext)
        
        let nota = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        nota.setValue(institution, forKey: "institution")
        nota.setValue(user, forKey: "user")
        nota.setValue(image, forKey: "photo")
        nota.setValue(id, forKey: "id")
        
        preferences[0].setValue(totalPhotos() + 1, forKey: "numberPhotos")

        var error: NSError?
        
        managedContext.save(&error)

        self.notas.append(nota)
    }
    
    func deleteNextPhoto () {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        var error : NSError?
        
        let entity =  NSEntityDescription.entityForName("Nota", inManagedObjectContext: managedContext)
        
        if (!notas.isEmpty) {
            managedContext.deleteObject(self.notas.last!)
            self.notas.removeLast()
        
            preferences[0].setValue(totalPhotos() - 1, forKey: "numberPhotos")
        
            managedContext.save(&error)
        }
    }
    
    func getNext () -> NSManagedObject {
        return notas.last!
    }
    
    func getImage (object: NSManagedObject) -> NSData {
        return object.valueForKey("photo") as NSData
    }
    
    func getId (object: NSManagedObject) -> NSString {
        return object.valueForKey("id") as NSString
    }
    
    func getInstitution (object: NSManagedObject) -> Int {
        return object.valueForKey("institution") as Int
    }
    
    // Regarging preferences database
    func set3G (status: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        var error : NSError?
        
        preferences[0].setValue(status, forKey: "hability3G")
        
        managedContext.save(&error)
    }
    
    func setInstitution (institution: Int) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        var error : NSError?
        
        preferences[0].setValue(institution, forKey: "institution")
        
        managedContext.save(&error)
    }
    
    func totalPhotos() -> Int {
        if (!preferences.isEmpty) {
            let preferencesInfo = preferences[0]
            let totalCount = preferencesInfo.valueForKeyPath("numberPhotos") as Int
            
            return totalCount
        }
        else {
            return 0
        }
    }
    
    func getHability3G () -> Bool {
        if (!preferences.isEmpty) {
            return preferences[0].valueForKey("hability3G") as Bool
        } else {
            return true
        }
    }
    
    func getInstitution () -> Int {
        if (!preferences.isEmpty) {
            let answer = preferences[0].valueForKey("institution") as Int
            
            return answer
        } else {
            return 1
        }
    }
    
    func userID () -> String {
        if (!preferences.isEmpty) {
            return preferences[0].valueForKey("userID") as String
        } else {
            return "undefined"
        }
    }
}
