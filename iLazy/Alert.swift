//
//  Alert.swift
//  iLazy
//
//  Created by East Agile on 4/13/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import UIKit

public struct AlertVar {
    static var loadingAlert: UIAlertController! = nil;
    static var alert: UIAlertController! = nil;
}

class Alert{

    class func loading(controller: UIViewController, message: String = "", completion: (() -> Void)?){
        if AlertVar.loadingAlert == nil {
            AlertVar.loadingAlert = UIAlertController(title: "Please wait", message: message + "\n", preferredStyle: .Alert)

            let indicator = UIActivityIndicatorView(frame: AlertVar.loadingAlert.view.bounds)
            indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            indicator.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            indicator.center = CGPointMake(AlertVar.loadingAlert.view.bounds.width / 2.0, AlertVar.loadingAlert.view.bounds.height / 2.0 + 25)
            indicator.userInteractionEnabled = false
            AlertVar.loadingAlert.view.addSubview(indicator)

            indicator.startAnimating()
        } else {
            AlertVar.loadingAlert.message = message + "\n"
        }
        controller.presentViewController(AlertVar.loadingAlert, animated: true, completion: completion)

    }

    class func hideLoading(){
        AlertVar.loadingAlert.dismissViewControllerAnimated(true, completion: nil)
    }

    class func error(controller: UIViewController, message: String = "", completion: (() -> Void)?){
        if AlertVar.alert == nil {
            AlertVar.alert = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
            AlertVar.alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        } else {
            AlertVar.alert.message = message
        }
        controller.presentViewController(AlertVar.alert, animated: true, completion: completion)
    }

    class func hideError(){
        AlertVar.alert.dismissViewControllerAnimated(true, completion: nil)
    }
}