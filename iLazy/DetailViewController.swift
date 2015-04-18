//
//  DetailViewController.swift
//  iLazy
//
//  Created by East Agile on 4/11/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {


    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var introductionTextView: UITextView!
    @IBOutlet weak var requestSiteTextView: UITextView!
    @IBOutlet weak var responseTextView: UITextView!
    @IBOutlet weak var parametersTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!

    var detailItem: AppInfo?

    func configureView() {
        // Update the user interface for the detail item.

        for textView in [introductionTextView,requestSiteTextView, responseTextView, parametersTextView] {
            textView.text = "Loading..."
        }

        if let detail = self.detailItem {
            appNameLabel.text = detail.name
            siteLabel.text = detail.site
            priceButton.setTitle(String(format: "%d", detail.price), forState: UIControlState.Normal)

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
