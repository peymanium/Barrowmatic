//
//  CoreDataHelper.swift
//  Barrowmatic
//
//  Created by Peyman Attarzadeh on 6/10/16.
//  Copyright © 2016 PeymaniuM. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper
{
    //static let helper = CoreDataHelper()
    //Use class keyword in front of the func name to use it as a sigleton
    static let instance = CoreDataHelper()
    
    func ManagedObjectContext() -> NSManagedObjectContext
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }
    
    
    func InsertManagedObject (className : NSString, managedObjectContext : NSManagedObjectContext) -> AnyObject
    {
        let managedObject = NSEntityDescription.insertNewObjectForEntityForName(className as String, inManagedObjectContext: managedObjectContext)
        
        return managedObject
    }
    
    
    func FetchEntities(className : NSString, managedObjectContext : NSManagedObjectContext, predicate : NSPredicate?, sortDescriptor : NSSortDescriptor?) -> NSArray //[AnyObject]
    {
        let fetchRequest = NSFetchRequest(entityName: className as String)
        
        fetchRequest.sortDescriptors = []
        if sortDescriptor != nil
        {
            fetchRequest.sortDescriptors?.append(sortDescriptor!)
        }
        
        if predicate != nil
        {
            fetchRequest.predicate = predicate
        }
        
        
        var items = []
        do
        {
            items = try managedObjectContext.executeFetchRequest(fetchRequest)
        }
        catch let error as NSError
        {
            print (error.debugDescription)
        }
        
        return items //as [AnyObject]
        
    }
    
    
    func SaveManagedObjectContext(managedObjectContext : NSManagedObjectContext)
    {
        
        do
        {
            try managedObjectContext.save()
        }
        catch let error as NSError
        {
            print (error.debugDescription)
        }
        
    }
    
}