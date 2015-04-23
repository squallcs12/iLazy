//
//  HelpViewController.swift
//  iLazy
//
//  Created by East Agile on 4/13/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController{

    @IBOutlet weak var siteTextField: UITextField!
    @IBOutlet weak var stepsTextField: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var scrollView: OrderScrollView!
    @IBOutlet weak var submitButton: UIButton!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var submitTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // text view border
        stepsTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        stepsTextField.layer.borderWidth = 1.0
        stepsTextField.layer.cornerRadius = 5

    }

    override func viewDidAppear(animated: Bool) {

        super.viewDidAppear(animated)
        // keyboard notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, submitTopConstraint.constant + submitButton.bounds.height + 10)

    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func submitPressed(sender: AnyObject) {
        if siteTextField.text == "" {
            Alert.error(self, message: "Please enter website"){
            }
            return
        }
        if stepsTextField.text == "" {
            Alert.error(self, message: "Please describe steps"){
            }
            return
        }
        if emailTextField.text == "" {
            Alert.error(self, message: "Please enter contact email"){
            }
            return
        }
        if priceTextField.text == "" {
            Alert.error(self, message: "Please choose an acceptable price"){
            }
            return
        }
        self.scrollView.endEditing(true)
        Alert.loading(self, message: "Submitting...", completion: nil)
        API.submitOrder(siteTextField.text, steps: stepsTextField.text, email: emailTextField.text, price: priceTextField.text){
            data, response, error in
            if data.objectForKey("success") as! Bool {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    Alert.hideLoading(){
                        Alert.success(self, message: "Your order has been placed on our system"){
                            self.emailTextField.text = ""
                            self.siteTextField.text = ""
                            self.stepsTextField.text = ""
                            self.priceTextField.text = ""
                        }
                    }
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    Alert.hideLoading(){
                        Alert.error(self, errors: data.objectForKey("errors") as! NSArray){
                        }
                    }
                })
            }

        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func keyboardWillShow(notification: NSNotification){

        let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
        let viewHeight = self.view.bounds.height
        bottomConstraint.constant = keyboardSize!.height - self.tabBarController!.tabBar.bounds.height
    }

    func keyboardWillHide(notification: NSNotification){
        bottomConstraint.constant = 0
    }
}
