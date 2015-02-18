//
//  DatabaseManager.swift
//  DoeNota
//
//  Created by Isa Sophia on 2/17/15.
//  Copyright (c) 2015 Isadora Sophia. All rights reserved.
//

import UIKit
import CoreData

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
        
        var fetchRequest = NSFetchRequest (entityName:"Nota")
        var fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
           notas = results
        }
        
        fetchRequest = NSFetchRequest (entityName: "Preferences")
        fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            preferences = results
        }
        
        if (preferences.isEmpty) {
            let entity =  NSEntityDescription.entityForName("Preferences", inManagedObjectContext: managedContext)
            
            let preference = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
            preference.setValue(true, forKey: "hability3G")
            preference.setValue(1, forKey: "institution")
            preference.setValue(0, forKey: "numberPhotos")
        }
    }
    
    func totalPhotos() -> Int {
        if (!preferences.isEmpty) {
            let preferencesInfo = preferences[0]
            let totalCount : String = preferencesInfo.valueForKeyPath("numberPhotos") as String
            let answer : Int? = totalCount.toInt()
            
            if (answer != nil) {
                return answer! 
            } else {
                return 0
            }
            
        }
        else {
            return 0
        }
    }
    
    func savePhoto(image: NSData, institution: NSString, user: NSString) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity =  NSEntityDescription.entityForName("Nota", inManagedObjectContext: managedContext)
        
        let nota = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        
        nota.setValue(institution, forKey: "institution")
        nota.setValue(user, forKey: "user")
        nota.setValue(image, forKey: "photo")

        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }

        notas.append(nota)
        preferences[0].setValue(totalPhotos() + 1, forKey: "numberPhotos")
    }
    
    func deleteNextPhoto () {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity =  NSEntityDescription.entityForName("Nota", inManagedObjectContext: managedContext)
        
        notas.removeLast()
    }
    
    func getNext () -> NSManagedObject {
        return notas[notas.endIndex]
    }
    
    func getImage (object: NSManagedObject) -> NSData {
        return object.valueForKey("photo") as NSData
    }
    
    func getUser (object: NSManagedObject) -> NSString {
        return object.valueForKey("user") as NSString
    }
    
    func getInstitution (object: NSManagedObject) -> NSString {
        return object.valueForKey("institution") as NSString
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
            let institution = preferences[0].valueForKey("institution") as String
            let answer : Int? = institution.toInt()
            
            if (answer != nil) {
                return answer!
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
}
