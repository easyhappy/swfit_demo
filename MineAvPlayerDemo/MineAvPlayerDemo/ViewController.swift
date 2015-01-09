//
//  ViewController.swift
//  MineAvPlayerDemo
//
//  Created by andyhu on 15/1/4.
//  Copyright (c) 2015年 andyhu. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var playerView: AVPlayerView!
    var playerItem: AVPlayerItem!
    var videoPlayer: AVPlayer!
    var videoTimeObserver: AnyObject!
    @IBOutlet weak var playVideoButton: UIButton!
    @IBOutlet weak var seeker: UISlider!
    @IBOutlet var singleTap: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "http://edge.v.iask.com.sinastorage.com/136681867.mp4")
        playerItem = AVPlayerItem(URL: url)
        self.videoPlayer = AVPlayer(playerItem: playerItem!)
        
        self.playerView.setPlayer(self.videoPlayer!)
        self.videoTimeObserver = self.videoPlayer!.addPeriodicTimeObserverForInterval(CMTimeMake(150, 600),
            queue: dispatch_get_main_queue(),
            usingBlock: {[unowned self](CMTime) in
                self.syncSeekber()
        })
        self.seeker.setValue(0, animated: true)
//        var tapGesture = UITapGestureRecognizer(target: self, action: "hidePlayerMenu")
//        //设置手势点击数,双击：点2下
//        tapGesture.numberOfTapsRequired = 1
//        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func syncSeekber(){
        var playerDuration: CMTime = playerItemDuration()
        if !playerDuration.isValid{
            return
        }
        let duration: Double = CMTimeGetSeconds(playerDuration)
        
        let currentTime: Double = CMTimeGetSeconds(self.videoPlayer!.currentTime())
        
        let progress: Float = Float(currentTime/duration)
        self.seeker.setValue(progress, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func isPaused() -> Bool{
        return self.videoPlayer.rate.isZero
    }
    
    @IBAction func playOrPause(sender: AnyObject){
        if self.isPaused(){
            self.videoPlayer.play()
        }else{
            self.videoPlayer.pause()
        }
        syncPlayPauseButtonImage()
    }

    @IBAction func hidePlayerMenu(){
        println("是的")
    }
    
    func syncPlayPauseButtonImage() {
        if self.isPaused() {
            self.playVideoButton.setImage(UIImage(named:"play.png"), forState: .Normal)
        } else {
            self.playVideoButton.setImage(UIImage(named:"pause.png"), forState: .Normal)
        }
    }
    
    func playerItemDuration() -> CMTime{
        let playerItem: AVPlayerItem = self.videoPlayer.currentItem
        if (playerItem.status == .ReadyToPlay){
            return playerItem.duration
        }
        return kCMTimeInvalid
    }


}

