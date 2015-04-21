//
//  LazyTableViewController.swift
//  iLazy
//
//  Created by East Agile on 4/14/15.
//  Copyright (c) 2015 Antipro. All rights reserved.
//

import UIKit
import CoreData

class LazyTableViewController: UITableViewController, UISplitViewControllerDelegate, UISearchBarDelegate {

    var objects = [App]()

    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    static var needReloaded = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.splitViewController?.delegate = self

        self.fetchAppList()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if LazyTableViewController.needReloaded {
            LazyTableViewController.needReloaded = false
            self.fetchAppList()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

        self.clearTable()
        LazyTableViewController.needReloaded = true
    }


    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showLazyDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! LazyViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("localCell", forIndexPath: indexPath) as! UITableViewCell
        let obj = self.objects[indexPath.row]
        cell.textLabel?.text = obj.name
        cell.detailTextLabel?.text = obj.site
        return cell
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func clearTable(){
        self.objects.removeAll(keepCapacity: true)
        self.tableView.reloadData()
    }

    @IBAction func reloadPressed(sender: AnyObject) {
        self.clearTable()
        Alert.loading(self, message: "Loading apps list from server...", completion: nil)
        API.myApps(){
            data, response, error in
            if data.objectForKey("success") as! Bool {

                let fetchRequest = NSFetchRequest(entityName: "App")

                if let fetchResults = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [App] {
                    for obj in fetchResults {
                        self.managedObjectContext!.deleteObject(obj)
                    }
                }
                self.managedObjectContext!.save(nil)
                let userApps = data.objectForKey("userapps") as! NSArray
                for userApp in userApps {
                    let newItem = App.fromUserAppDict(userApp as! NSDictionary, context: self.managedObjectContext!)
                }
                self.managedObjectContext!.save(nil)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    Alert.hideLoading(nil)
                    self.fetchAppList()
                })
            }
        }
    }

    // Fetch app list from core data into table view
    func fetchAppList(){
        let fetchRequest = NSFetchRequest(entityName: "App")

        if let fetchResults = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [App] {
            var indexPaths = [NSIndexPath]()

            for obj in fetchResults {
                var indexPath = NSIndexPath(forRow: indexPaths.count, inSection: 0)
                indexPaths.append(indexPath)
                self.objects.append(obj)
            }

            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            self.tableView.reloadData()
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UISplitViewControllerDelegate



    // MARK: split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
            if let topAsDetailController = secondaryAsNavController.topViewController as? LazyViewController {
                if topAsDetailController.detailItem == nil {
                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
                    return true
                }
            }
        }
        return false
    }
}
