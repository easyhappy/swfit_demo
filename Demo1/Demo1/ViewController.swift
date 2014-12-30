//
//  ViewController.swift
//  Demo1
//
//  Created by andyhu on 14/12/30.
//  Copyright (c) 2014年 andyhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // UIKit物理引擎
    var animator: UIDynamicAnimator!;
    
    // 重力行为
    var gravity: UIGravityBehavior!;
    
    override func viewDidLoad() {
       
        // Do any additional setup after loading the view, typically from a nib.
        let square = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100));
        square.backgroundColor = UIColor.cyanColor();
        self.view.addSubview(square);
        // 实例化UIKit物理引擎类，作用于ViewController的View
        animator = UIDynamicAnimator(referenceView: self.view);
        
        // 实例化重力行为类，目前只作用于刚才创建的正方形View
        gravity = UIGravityBehavior(items: [square]);
        
        // 将重力行为添加到UIKit物理引擎类中
        animator.addBehavior(gravity);
        
         super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

