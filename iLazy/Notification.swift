//
//  Notification.swift
//  iLazy
//
//  Created by East Agile on 4/28/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import Foundation
import CoreData

class Notification: NSManagedObject {

    @NSManaged var url: String
    @NSManaged var title: String
    @NSManaged var detail: String
    @NSManaged var message: String
    @NSManaged var app: App

}
