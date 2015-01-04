//
//  VideoTableViewController.swift
//  RBStoryboarLinkDemo2
//
//  Created by andyhu on 15/1/3.
//  Copyright (c) 2015年 andyhu. All rights reserved.
//

import UIKit

class VideoTableViewController: UITableViewController, HttpProtocol {
    var eHttp:HttpController = HttpController()
    var tableData:NSArray = NSArray()
    @IBOutlet var tv: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        eHttp.delegate = self
        eHttp.onSearch("http://127.0.0.1:3000/game_videos")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func didReceiveResults(results: NSDictionary) {
        //self.tv.reload()
        self.tableData = results["data"] as NSArray
        self.tv.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tableData.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("game_videos", forIndexPath: indexPath) as VideoTableViewCell
        
        let rowData:NSDictionary = self.tableData[indexPath.row] as NSDictionary
        let url = rowData["img"] as? String
        
        cell.videoTitle.text = rowData["title"] as? String
        
        if url != nil {
            var url:NSURL = NSURL(string: url!)!
            var request = NSURLRequest(URL:url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
                    let img = UIImage(data:data)
                    cell.imgView.image = img
                })
        }else{
            cell.imgView.image = UIImage(named: "1.jpg")
        }

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        if segue.identifier == "showVideoDetail"{
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let destinationController = segue.destinationViewController as VideoDetailViewController
                destinationController.gameVideo = self.tableData[indexPath.row] as NSDictionary
            }
        }
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
