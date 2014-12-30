//
//  ViewController.swift
//  videoTest
//
//  Created by andyhu on 14/12/10.
//  Copyright (c) 2014年 andyhu. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    var moviePlayer:MPMoviePlayerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        var url:NSURL = NSURL(string: "http://edge.v.iask.com.sinastorage.com/136561824.mp4")!
        
        moviePlayer = MPMoviePlayerController(contentURL: url)
        
        moviePlayer.view.frame = CGRect(x: 20, y: 100, width: 200, height: 150)
        
        self.view.addSubview(moviePlayer.view)
        
        moviePlayer.fullscreen = true
        
        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
        moviePlayer.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

