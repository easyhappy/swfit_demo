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
    // 碰撞行为
    var collision: UICollisionBehavior!;
    
    override func viewDidLoad() {
       
        // Do any additional setup after loading the view, typically from a nib.
        let square = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100));
        square.backgroundColor = UIColor.cyanColor();
        self.view.addSubview(square);
        
        
        // 创建一个长方形View，颜色设置为红色，加入当前的View中
        let barrier = UIView(frame:CGRect(x: 0, y: 300, width: 140, height: 20));
        barrier.backgroundColor = UIColor.redColor();
        self.view.addSubview(barrier);
        
        // 实例化UIKit物理引擎类，作用于ViewController的View
        animator = UIDynamicAnimator(referenceView: self.view);
        
        // 实例化重力行为类，目前只作用于刚才创建的正方形View
        gravity = UIGravityBehavior(items: [square]);
        // 角度
        gravity.angle = 1.6;
        
        // 速率
        //gravity.magnitude = 0.1;
        
        // 将重力行为添加到UIKit物理引擎类中
        // 实例化碰撞行为类，目前只作用于刚才创建的正方形View
        collision = UICollisionBehavior(items: [square]);
        collision.addBoundaryWithIdentifier("barrier", forPath: UIBezierPath(rect: barrier.frame));
        
        // 将参考视图的边界作为碰撞边界
        collision.translatesReferenceBoundsIntoBoundary = true;
        
        // 将碰撞行为添加到UIKit物理引擎类中
        animator.addBehavior(collision);
        animator.addBehavior(gravity);
        
        
         super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

