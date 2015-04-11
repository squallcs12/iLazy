//
//  ViewController.swift
//  iLazy
//
//  Created by East Agile on 4/10/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var loadingAlert: UIAlertController! = nil;
    var alert: UIAlertController! = nil;

    var delegate: UISplitViewControllerDelegate! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signinPressed(sender: UIButton) {
        if self.alert == nil {
            self.alert = UIAlertController(title: "Error", message: "Please enter username and password.", preferredStyle: .Alert)
            self.alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        }
        if usernameTextField.text == "" || passwordTextField.text == "" {
                self.alert.title = "Error"
                self.alert.message = "Please enter username and password."

                self.presentViewController(self.alert, animated: true, completion: nil)
            return
        }

        if self.loadingAlert == nil {

            self.loadingAlert = UIAlertController(title: "Please wait", message: "Verifying username and password...\n", preferredStyle: .Alert)

            let indicator = UIActivityIndicatorView(frame: self.loadingAlert.view.bounds)
            indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            indicator.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            indicator.center = CGPointMake(self.loadingAlert.view.bounds.width / 2.0, self.loadingAlert.view.bounds.height / 2.0 + 25)
            indicator.userInteractionEnabled = false
            self.loadingAlert.view.addSubview(indicator)
            indicator.startAnimating()

        }

        self.presentViewController(loadingAlert, animated: true, completion: nil)

        API.login(usernameTextField.text, password: passwordTextField.text){
            data, response, error in
            self.loadingAlert.dismissViewControllerAnimated(true){

                if data.objectForKey("success") as! Bool {
                    self.performSegueWithIdentifier("showSplitViewController", sender: self)
                } else {
                    let errors = data.objectForKey("errors") as! NSArray
                    if let message = errors[0].objectForKey("message") as? String {
                        self.alert.message = message
                    } else {
                        self.alert.message = "Unable to login, please try again later."
                    }

                    self.presentViewController(self.alert, animated: true, completion: nil)
                }
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSplitViewController" {
            let controller = segue.destinationViewController as! UISplitViewController
            controller.delegate = self.delegate
        }
    }
}

