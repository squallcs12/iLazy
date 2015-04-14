//
//  OrderScrollView.swift
//  iLazy
//
//  Created by East Agile on 4/14/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import UIKit

class OrderScrollView: UIScrollView {
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.endEditing(true)
    }
}
