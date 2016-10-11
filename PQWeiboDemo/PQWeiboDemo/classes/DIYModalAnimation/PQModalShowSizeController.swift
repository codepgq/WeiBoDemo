//
//  PQModalShowSizeController.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/9.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQModalShowSizeController: UIPresentationController {
    /// 定义属性保存菜单的大小
    var presentFrame = CGRect.zero
    
    /**
     初始化方法，用于创建负责转场动画的对象
     
     - parameter presentedViewController:  被展现的控制器
     - parameter presentingViewController: 发起的控制器
     
     - returns: 返回负责转场动画的对象
     */
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting : presentingViewController)
    }
    
    /**
     即将布局转场子视图时调用
     */
    override func containerViewWillLayoutSubviews() {
        // 1、修改弹出视图的大小
        if presentFrame == CGRect.zero {
            presentedView?.frame = UIScreen.main.bounds
        }else{
            presentedView?.frame = presentFrame
        }
        
        // 2、在容器上添加一个蒙版，插入到图层最底层
        containerView?.insertSubview(coverView, at: 0)
    }
    
    private lazy var coverView : UIView = {
        // 1、创建View
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        view.frame = UIScreen.main.bounds
        
        //2、添加监听
        let tap = UITapGestureRecognizer(target: self, action: #selector(PQModalShowSizeController.close))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    @objc private func close(){
        //presentedViewController 当前弹出的控制器
        presentedViewController.dismiss(animated: true, completion: nil)
    }

}
