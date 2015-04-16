//
//  Param.swift
//  iLazy
//
//  Created by East Agile on 4/16/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import Foundation
import CoreData

class Param: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var type: String
    @NSManaged var options: String
    @NSManaged var app: App

}
