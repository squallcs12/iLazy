//
//  CustomTextField.swift
//  iLazy
//
//  Created by East Agile on 4/21/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    var currentText: String?
    var error: String?
    var currentTextColor: UIColor?
    var borderColor: CGColor?

    func showError(message: String){
        self.currentTextColor = self.textColor
        self.currentText = self.text
        self.borderColor = self.layer.borderColor
        self.error = message

        self.textColor = UIColor.redColor()
        self.textAlignment = .Right
        self.text = message
        self.layer.borderColor = UIColor.redColor().CGColor
    }

    func showCurrentText(){
        self.text = self.currentText
        self.textColor = self.currentTextColor
        self.textAlignment = .Left
        self.layer.borderColor = self.borderColor
    }
}
