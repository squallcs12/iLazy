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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signinPressed(sender: AnyObject) {
        if usernameTextField.text == "" || passwordTextField.text == "" {
            Alert.error(self, message: "Please enter username and password.", completion: nil)
            return
        }

        Alert.loading(self, message: "Verifying username and password...", completion: nil)

        API.login(usernameTextField.text, password: passwordTextField.text){
            data, response, error in
            Alert.hideLoading(){
                if let error = data.objectForKey("error") as! String!{
                    Alert.error(self, message: (data.objectForKey("error_description") as? String)!, completion: nil)
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

