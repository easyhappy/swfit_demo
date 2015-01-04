//
//  ViewController.swift
//  VideoPlayer
//
//  Created by messel on 8/22/14.
//  Copyright (c) 2014 messel. All rights reserved.
//

import UIKit
import CoreMedia
import MediaPlayer

class ViewController: UIViewController {

    
    @IBOutlet var urlField : UITextField!
    var moviePlayer : MPMoviePlayerViewController?
    
    @IBAction func tapGesture(sender: AnyObject) {
        urlField.resignFirstResponder()
        NSLog("tapGesture called " + urlField.text)
    }

    @IBAction func urlChanged(sender: AnyObject) {
        NSLog("urlChanged called " + urlField.text)
        playVideo()
    }

    @IBAction func playPushed(sender: AnyObject) {
        NSLog("playPushed called " + urlField.text)
        playVideo()
    }
    
    var url = "http://124.228.42.141/n/5/92/2045/136585900.hlv"
//    var url = "http://api.cameo.tv/file/9bafd29deafc16edbfdc8dfcbc0489d1895c7178"
    
    
    func initValues() {
        urlField.text = url;
    }

    func playVideo() {
        let videoURL = NSURL(string: urlField.text)
        moviePlayer = MPMoviePlayerViewController(contentURL: videoURL )
        NSLog("about to play video " + urlField.text)
        if let player = moviePlayer {
            NSLog("setting stuff")
            player.view.frame = self.view.bounds
            self.presentViewController(moviePlayer!, animated: true, completion: nil)
            NSLog("all done")
        }
        else {
            NSLog("no player")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

