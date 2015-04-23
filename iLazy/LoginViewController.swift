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
    var tabBarContrl: TabBarController? = nil
    var confirmPasswordTextField: UITextField!

    let registerAlertController = UIAlertController(title: "Register", message: "Confirm your password", preferredStyle: UIAlertControllerStyle.Alert)
    var registerAction: UIAlertAction!

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

        self.passwordTextField.delegate = self

        registerAlertController.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.secureTextEntry = true
            self.confirmPasswordTextField = textField

            NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleTextFieldTextDidChangeNotification:", name: UITextFieldTextDidChangeNotification, object: textField)
        })

        func registerPressed(alertAction: UIAlertAction!){
            Alert.loading(self, message: "Registering", completion: nil)

            API.register(usernameTextField.text, password: passwordTextField.text){
                data, response, error in
                if data.objectForKey("success") as! Bool {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        Alert.hideLoading(){
                            self.signinPressed(self)
                        }
                    })
                } else {
                    let errors = data.objectForKey("errors") as! NSArray
                    var errorString = ""
                    for _error in errors {
                        let error = _error as! NSDictionary
                        errorString += error.objectForKey("message") as! String + "\n"
                    }
                    Alert.error(self, message: errorString, completion: nil)
                }
            }
        }

        registerAction = UIAlertAction(title: "Register", style: UIAlertActionStyle.Default, handler: registerPressed)
        registerAction.enabled = false

        registerAlertController.addAction(registerAction)

        let cancleAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        registerAlertController.addAction(cancleAction)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerPressed(sender: AnyObject) {
        if !testLoginForm() {
            return
        }
        registerAction.enabled = false
        confirmPasswordTextField.text = ""
        self.presentViewController(registerAlertController, animated: true, completion: nil)
    }

    func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        let textField = notification.object as! UITextField
        if textField.text == passwordTextField.text {
            registerAction.enabled = true
        } else {
            registerAction.enabled = false
        }
    }

    func testLoginForm() -> Bool{
        if usernameTextField.text == "" || passwordTextField.text == "" {
            Alert.error(self, message: "Please enter username and password.", completion: nil)
            return false
        }
        return true
    }

    @IBAction func signinPressed(sender: AnyObject) {
        if !testLoginForm() {
            return
        }

        Alert.loading(self, message: "Verifying username and password...", completion: nil)

        API.login(usernameTextField.text, password: passwordTextField.text){
            data, response, error in
            Alert.hideLoading(){
                if let error = data.objectForKey("error") as! String!{
                    Alert.error(self, message: (data.objectForKey("error_description") as? String)!, completion: nil)
                } else {
                    Alert.hideError()
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

