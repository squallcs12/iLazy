//
//  App.swift
//  iLazy
//
//  Created by East Agile on 4/16/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import Foundation
import CoreData

class App: NSManagedObject {


    @NSManaged var name: String
    @NSManaged var site: String
    @NSManaged var introduction: String
    @NSManaged var id: NSNumber
    @NSManaged var price: NSNumber
    @NSManaged var expires: NSDate
    @NSManaged var relationship: Param
    @NSManaged var relationship1: Instance

    class func fromUserAppDict(userApp: NSDictionary, context: NSManagedObjectContext) -> App{
        let appInfo = AppInfo.fromDict(userApp.objectForKey("app") as! NSDictionary)
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("App", inManagedObjectContext: context) as! App
        newItem.name = appInfo.name
        newItem.site = appInfo.site
        newItem.id = appInfo.id
        newItem.price = appInfo.price
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        newItem.expires = dateFormater.dateFromString(userApp.objectForKey("expires") as! String)!
        return newItem
    }

}
