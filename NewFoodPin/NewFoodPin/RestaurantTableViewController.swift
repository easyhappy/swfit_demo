//
//  RestaurantTableViewController.swift
//  NewFoodPin
//
//  Created by andyhu on 14/11/30.
//  Copyright (c) 2014年 andyhu. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {

    var restaurantNames = ["Cafe Deadend", "andyhu", "Teakha", "Cafe Loisl", "Petite Oyster"]
    var restaurantImages = ["cafedeadend.jpg", "homei.jpg", "teakha.jpg", "cafeloisl.jpg","petiteoyster.jpg"]
    
    var restaurants:[Restaurant] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()];
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        if segue.identifier == "showRestaurantDetail"{
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let destinationController = segue.destinationViewController as DetailViewController
                destinationController.restaurantImage = "listen_katong.jpeg"
                destinationController.restaurant = restaurants[indexPath.row]
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return restaurants.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as CustomTableViewCell
        
        var restaurant:Restaurant = restaurants[indexPath.row]
        
        cell.nameLabel.text = restaurants[indexPath.row].name
        cell.thumbnailImageView.image = UIImage(data: restaurant.image)
        cell.thumbnailImageView.layer.cornerRadius = cell.thumbnailImageView.frame.size.width / 2
        cell.thumbnailImageView.clipsToBounds = true
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    /*override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let optionMenu = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, the call feature is not available yet. Please retry later.", preferredStyle: .Alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertMessage, animated: true, completion: nil)
        }
        let callAction = UIAlertAction(title: "Call " + "123-000-\(indexPath.row)", style:
            UIAlertActionStyle.Destructive, handler: callActionHandler)
        
        
        
        let isVistedAction = UIAlertAction(title: "I've here", style: .Default, handler: {(action: UIAlertAction!) -> Void in
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                cell?.accessoryType = .Checkmark
                tableView.deselectRowAtIndexPath(indexPath, animated: false)
            })
        
        optionMenu.addAction(callAction)
        optionMenu.addAction(isVistedAction)
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }*/
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle:
                UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            self.restaurants.removeAtIndex(indexPath.row)
            self.tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        }
    }
    
    // 滑动按钮之后 更多的action
    
     override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath:
        NSIndexPath) -> [AnyObject] {
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title:
        "Share", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
    
        let shareMenu = UIAlertController(title: nil, message: "Share using",
        preferredStyle: .ActionSheet)
        let twitterAction = UIAlertAction(title: "Twitter", style:
        UIAlertActionStyle.Default, handler: nil)
        let facebookAction = UIAlertAction(title: "Facebook", style:
        UIAlertActionStyle.Default, handler: nil)
        let emailAction = UIAlertAction(title: "Email", style: UIAlertActionStyle.Default,
        handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel,
        handler: nil)
        shareMenu.addAction(twitterAction)
        shareMenu.addAction(facebookAction)
        shareMenu.addAction(emailAction)
        shareMenu.addAction(cancelAction)
        self.presentViewController(shareMenu, animated: true, completion: nil)
        }
        )
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default,
        title: "Delete",handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
        // Delete the row from the data source
        self.restaurants.removeAtIndex(indexPath.row)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        )
        shareAction.backgroundColor = UIColor(red: 255.0/255.0, green: 166.0/255.0, blue:
        51.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue:
        51.0/255.0, alpha: 1.0)
        return [deleteAction, shareAction]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe  = true
    }
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
    }

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

}
