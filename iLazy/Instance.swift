//
//  Instance.swift
//  iLazy
//
//  Created by East Agile on 4/16/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import Foundation
import CoreData

class Instance: NSManagedObject {

    @NSManaged var result_id: NSNumber
    @NSManaged var params: String
    @NSManaged var app: App

}
