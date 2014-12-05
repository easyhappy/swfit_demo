//
//  DetailViewController.swift
//  NewFoodPin
//
//  Created by andyhu on 14/12/1.
//  Copyright (c) 2014年 andyhu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var RestaurantImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var restaurantImage:String!
    var restaurant:Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestaurantImageView.image = UIImage(named: restaurantImage)
        //self.tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue:240.0/255.0, alpha: 0.2)
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.separatorColor = UIColor(red:
                240.0/255.0, green: 240.0/255.0, blue: 10/255.0,
                alpha: 0.8)
        title = self.restaurant.name
        //RestaurantImageView.image = UIImage(named: "listen_katong.jpeg")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.hidesBarsOnSwipe = false
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailIndentifier", forIndexPath: indexPath) as DetailTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        switch indexPath.row{
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurant.type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = "Been here"
            cell.valueLabel.text = "Yes, I’ve been here before"
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = "hhhhh"
        }
            return cell
    }
    
    @IBAction func close(segue:UIStoryboardSegue) {
    }

    override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      self.navigationController?.hidesBarsOnSwipe = false
      self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
