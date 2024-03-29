//
//  Alert.swift
//  iLazy
//
//  Created by East Agile on 4/13/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import UIKit

public struct AlertVar {
    static var loadingAlert: UIAlertController! = nil
    static var alertUrl: UIAlertController! = nil
    static var alert: UIAlertController! = nil
}

class Alert{

    static var visitAction:UIAlertAction! = nil
    static var url: String! = nil

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

    class func hideLoading(completion: (() -> Void)?){
        if AlertVar.loadingAlert != nil {
            AlertVar.loadingAlert.dismissViewControllerAnimated(true, completion: completion)
        } else {
            completion?()
        }
    }

    class func initAlert(){
        if AlertVar.alert == nil {
            AlertVar.alert = UIAlertController(title: "Error", message: "", preferredStyle: .Alert)
            AlertVar.alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        }
    }

    class func visitActionPressed(action: UIAlertAction!){
        UIApplication.sharedApplication().openURL(NSURL(string: Alert.url)!)
    }

    class func initAlertUrl(){
        if AlertVar.alertUrl == nil {
            AlertVar.alertUrl = UIAlertController(title: "", message: "", preferredStyle: .Alert)
            AlertVar.alertUrl.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            Alert.visitAction = UIAlertAction(title: "Visit", style: UIAlertActionStyle.Default, handler: visitActionPressed)
            AlertVar.alertUrl.addAction(Alert.visitAction)
        }
    }

    class func alertUrl(controller: UIViewController, title: String, message: String, url: String, completion: (() -> Void)?){
        Alert.initAlertUrl()
        AlertVar.alertUrl.title = title
        AlertVar.alertUrl.message = message
        Alert.url = url
        controller.presentViewController(AlertVar.alertUrl, animated: true, completion: completion)
    }

    class func error(controller: UIViewController, message: String = "", completion: (() -> Void)?){
        Alert.initAlert()
        AlertVar.alert.message = message
        AlertVar.alert.title = "Error"
        controller.presentViewController(AlertVar.alert, animated: true, completion: completion)
    }

    class func error(controller: UIViewController, errors: NSArray, completion: (() -> Void)?){
        var errorMessage = ""
        let fieldErrors = errors[0] as! NSDictionary

        for (field, errorList) in fieldErrors {
            errorMessage += (field as! String) + "\n"
            for error in (errorList as! NSArray) {
                errorMessage += (error as! String) + "\n"
            }
        }
        Alert.error(controller, message: errorMessage, completion: completion)
    }

    class func success(controller: UIViewController, message: String = "", completion: (() -> Void)?){
        Alert.initAlert()
        AlertVar.alert.message = message
        AlertVar.alert.title = "Success"
        controller.presentViewController(AlertVar.alert, animated: true, completion: completion)
    }

    class func hideError(){
        if AlertVar.alert != nil {
            AlertVar.alert.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}