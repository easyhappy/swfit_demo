//
//  VideoDetailViewController.swift
//  RBStoryboarLinkDemo2
//
//  Created by andyhu on 15/1/4.
//  Copyright (c) 2015年 andyhu. All rights reserved.
//

import UIKit

class VideoDetailViewController: UIViewController {
    var gameVideo:NSDictionary!;
    
    @IBOutlet weak var videoTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.videoTitle.text = (self.gameVideo["title"] as String)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
