//
//  TabBarController.swift
//  iLazy
//
//  Created by East Agile on 4/13/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    static var instance: TabBarController! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        TabBarController.instance = self
    }
}
