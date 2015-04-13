//
//  ViewController.swift
//  iLazy
//
//  Created by East Agile on 4/10/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var loadingAlert: UIAlertController! = nil;
    var alert: UIAlertController! = nil;

    var tabBarContrl: TabBarController? = nil

    override func viewDidAppear(animated: Bool) {
        let (data, error) = Locksmith.loadDataForUserAccount("myUserAccount")
        if let accessToken = data?.objectForKey("access_token") as! String! {
            Client.accessToken = data?.objectForKey("access_token") as! String!
            Client.refreshToken = data?.objectForKey("refresh_token") as! String!
            Client.tokenType = data?.objectForKey("token_type") as! String!
            self.performSegueWithIdentifier("afterLoginSegue", sender: self)
            return;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        self.alert = UIAlertController(title: "Error", message: "Please enter username and password.", preferredStyle: .Alert)
        self.alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))


        self.loadingAlert = UIAlertController(title: "Please wait", message: "Verifying username and password...\n", preferredStyle: .Alert)

        let indicator = UIActivityIndicatorView(frame: self.loadingAlert.view.bounds)
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        indicator.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        indicator.center = CGPointMake(self.loadingAlert.view.bounds.width / 2.0, self.loadingAlert.view.bounds.height / 2.0 + 25)
        indicator.userInteractionEnabled = false
        self.loadingAlert.view.addSubview(indicator)
        indicator.startAnimating()

        self.passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signinPressed(sender: AnyObject) {
        if usernameTextField.text == "" || passwordTextField.text == "" {
                self.alert.title = "Error"
                self.alert.message = "Please enter username and password."

                self.presentViewController(self.alert, animated: true, completion: nil)
            return
        }

        self.presentViewController(loadingAlert, animated: true, completion: nil)

        API.login(usernameTextField.text, password: passwordTextField.text){
            data, response, error in
            self.loadingAlert.dismissViewControllerAnimated(true){
                if let error = data.objectForKey("error") as! String!{
                    self.alert.title = error
                    self.alert.message = data.objectForKey("error_description") as? String

                    self.presentViewController(self.alert, animated: true, completion: nil)
                } else {
                    self.performSegueWithIdentifier("afterLoginSegue", sender: self)
                }
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "afterLoginSegue" {
            self.tabBarContrl = (segue.destinationViewController as! TabBarController)
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.passwordTextField{
            textField.resignFirstResponder()
            self.signinPressed(textField)
            return false
        }
        return true
    }
}

