//
//  AVPlayerView.swift
//  MineAvPlayerDemo
//
//  Created by andyhu on 15/1/4.
//  Copyright (c) 2015年 andyhu. All rights reserved.
//

import UIKit
import AVFoundation

class AVPlayerView: UIView{
    func setPlayer(player: AVPlayer!){
        let layer: AVPlayerLayer = self.layer as AVPlayerLayer
        layer.player = player
    }
    
    override class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }
}