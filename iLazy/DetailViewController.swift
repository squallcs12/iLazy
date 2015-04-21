//
//  DetailViewController.swift
//  iLazy
//
//  Created by East Agile on 4/11/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextViewDelegate {


    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var expiresLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var introductionTextView: UITextView!
    @IBOutlet weak var requestSiteTextView: UITextView!
    @IBOutlet weak var responseTextView: UITextView!
    @IBOutlet weak var parametersTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!

    var detailItem: AppInfo?
    var localItem: App?

    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    func configureView() {
        // Update the user interface for the detail item.

        for textView in [introductionTextView,requestSiteTextView, responseTextView, parametersTextView] {
            textView.text = "Loading..."
        }

        if let detail = self.detailItem {
            appNameLabel.text = detail.name
            siteLabel.text = detail.site
            expiresLabel.text = ""
            expiresLabel.text = detail.expiresStr()
            priceButton.setTitle(String(format: "%dC", detail.price), forState: .Normal)

            API.fetchApp(detail.id) {
                data, response, error in
                if data.objectForKey("success") as! Bool {
                    let app = data.objectForKey("app") as! NSDictionary

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.introductionTextView.text = app.objectForKey("introduction") as! String
                        self.requestSiteTextView.text = app.objectForKey("request_sites") as! String
                        self.responseTextView.text = app.objectForKey("responses") as! String
                        self.parametersTextView.text = app.objectForKey("require_params") as! String
                    })
                }
            }


            if localItem == nil {
                // find in core data first
                let request = NSFetchRequest(entityName: "App")

                let pred = NSPredicate(format: "(id = %@)", detail.id)
                request.predicate = pred

                var error: NSError?

                var objects = managedObjectContext?.executeFetchRequest(request,
                    error: &error)
                
                if let results = objects {
                    if results.count > 0 {
                        self.localItem = results[0] as? App
                        expiresLabel.text = AppInfo.expiresStr(localItem?.expires)
                    } else {
                        API.myApp(detail.id){
                            data, response, error in
                            if response.statusCode == 200 {
                                let userApp = data.objectForKey("userapp") as! NSDictionary
                                self.localItem = App.fromUserAppDict(userApp, context: self.managedObjectContext!)
                                self.managedObjectContext?.save(nil)
                                LazyTableViewController.needReloaded = true
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.expiresLabel.text = AppInfo.expiresStr(self.localItem?.expires)
                                })
                            }
                        }
                    }
                }
            }
        }

    }

    func resetPriceButton(){
        self.priceButton.backgroundColor = self.expiresLabel.textColor
        self.priceButton.enabled = true
        self.priceButton.setTitle(String(format: "%dC", self.detailItem!.price), forState: .Normal)
    }

    @IBAction func priceButtonPressed(sender: AnyObject) {
        if self.priceButton.titleLabel?.text == "Buy" {
            self.priceButton.setTitle("Buying", forState: .Normal)
            self.expiresLabel.text = "..."
            self.priceButton.enabled = false

            API.purchaseApp(detailItem?.id as! Int){
                data, response, error in

                if data.objectForKey("success") as! Bool {
                    let userApp = data.objectForKey("user_app") as! NSDictionary
                    let expiresStr = userApp.objectForKey("expires_str") as! String
                    self.expiresLabel.text = expiresStr
                    self.resetPriceButton()
                } else {
                    let errors = data.objectForKey("errors") as! NSArray
                    Alert.error(self, message: errors[0].objectForKey("message") as! String){
                        self.resetPriceButton()
                    }
                }
            }
        } else {
            self.priceButton.setTitle("Buy", forState: UIControlState.Normal)
            self.priceButton.backgroundColor = UIColor(red: 82/255.0, green: 210/255.0, blue: 102/255.0, alpha: 1)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
