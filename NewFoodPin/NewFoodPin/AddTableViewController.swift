//
//  AddTableViewController.swift
//  NewFoodPin
//
//  Created by andyhu on 14/12/5.
//  Copyright (c) 2014年 andyhu. All rights reserved.
//

import UIKit
import CoreData

class AddTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var restaurant:Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(sender: AnyObject) {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as
            AppDelegate).managedObjectContext
        self.restaurant = NSEntityDescription.insertNewObjectForEntityForName("Restaurant",
                inManagedObjectContext: managedObjectContext!) as Restaurant
        restaurant.image = UIImagePNGRepresentation(imageView.image)
        restaurant.name = "aaaaa"
        var e: NSError?
        if(managedObjectContext?.save(&e) == true){
            println("yes save success")
        }
        return 
    
    }
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image:
        UIImage!, editingInfo: [NSObject : AnyObject]!) {
    
        imageView.image = image
        236
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func navigationController(navigationController: UINavigationController!,
            willShowViewController viewController: UIViewController!, animated: Bool) {
            UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:
        NSIndexPath) {
        if indexPath.row == 0 {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Table view data source

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

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

}
