//
//  TabBarController.swift
//  iLazy
//
//  Created by East Agile on 4/13/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // set delegate to UISplitViewController
        let count = self.viewControllers!.count - 1
        for i in 0...count {
            var vc: AnyObject = viewControllers![i]
            if vc is UISplitViewController {
                let x = vc as! UISplitViewController
                x.delegate = Static.delegate
            }
        }
    }
}
