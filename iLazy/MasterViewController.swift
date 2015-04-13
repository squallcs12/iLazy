//
//  MasterViewController.swift
//  iLazy
//
//  Created by East Agile on 4/11/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import UIKit

struct App {
    let name: String;
    let site: String;
    let price: Double;
}

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [App]()

    var addButton: UIBarButtonItem? = nil
    var doneButton: UIBarButtonItem? = nil

    var showPrice: Bool = false


    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }

        self.addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "browseOnlinePackage:")
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "browseLocalPackage:")
        self.setupExistsList()
    }

    func setupExistsList(){
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = self.addButton
        self.showPrice = false
    }

    func setupBrowseList(){
        self.navigationItem.leftBarButtonItem = self.doneButton
        self.navigationItem.rightBarButtonItem = nil
        self.showPrice = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func browseLocalPackage(sender: AnyObject){
        self.setupExistsList()
    }

    func browseOnlinePackage(sender: AnyObject) {
        self.setupBrowseList()
        API.fetchApps(){
            data, response, error in
            if data.objectForKey("success") as! Bool {
                let apps = data.objectForKey("apps") as! NSArray
                var indexPaths = [NSIndexPath]()
                for _app in apps {
                    var app = App(
                        name: _app.objectForKey("name") as! String,
                        site: _app.objectForKey("site") as! String,
                        price: _app.objectForKey("price") as! Double)
                    var indexPath = NSIndexPath(forRow: indexPaths.count, inSection: 0)
                    indexPaths.append(indexPath)
                    self.objects.append(app)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                    self.tableView.reloadData()

                })
            } else {

            }

        }
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:AppCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AppCell
        let obj = self.objects[indexPath.row]
        cell.setApp(obj)
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

