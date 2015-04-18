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
    @NSManaged var relationship: Param
    @NSManaged var relationship1: Instance

}
