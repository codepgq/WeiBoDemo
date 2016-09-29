//
//  PQIndexTableVC.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/12.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQIndexTableVC: PQBaseTableVC,UIViewControllerTransitioningDelegate {
    
    private lazy var navigatorCenter : PQLIRTButton = {
        let center : PQLIRTButton = PQLIRTButton()
        center.setTitle("纸巾艺术", forState: .Normal)
        center.setImage(UIImage(named: "navigationbar_arrow_down"), forState: .Normal)
        center.setImage(UIImage(named: "navigationbar_arrow_up"), forState: .Selected)
        center.sizeToFit()
        center.addTarget(self, action: #selector(PQIndexTableVC.centerBtnClick), forControlEvents: .TouchUpInside)
        return center
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PQIndexTableVC.popMenuNotifaction), name: popoverViewWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PQIndexTableVC.popMenuNotifaction), name: popoverViewWillClose, object: nil)
    }
    
    //通过通知来改变按钮图片
    @objc private func popMenuNotifaction(){
        navigatorCenter.selected = !navigatorCenter.selected
    }
    
    deinit{
        //移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setVisitorIsIndex(true, imageNamed: "visitordiscover_feed_image_house",hiddenAll:false)
        
        //登录了才显示
        if isLogin {
            //创建左右中间按钮
            navigationItem.leftBarButtonItem = UIBarButtonItem.createSelecedtButton("navigationbar_friendattention", target: self, action: #selector(PQIndexTableVC.leftBtnClick))
            navigationItem.rightBarButtonItem = UIBarButtonItem.createSelecedtButton("navigationbar_pop", target: self, action: #selector(PQIndexTableVC.rightBtnClick))
            navigationItem.titleView =  navigatorCenter
        }
    }
    /**
     左按钮点击事件
     */
    @objc private func leftBtnClick(){
        if isLogin {
            print("我")
        }
        else{
            print("注册")
        }
    }
    
    /**
     右按钮点击事件
     */
    @objc private func rightBtnClick(){
        let vc = UIStoryboard(name: "QRCode", bundle: nil).instantiateInitialViewController()
        navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    /**
     中间按钮点击事件
     */
    @objc private func centerBtnClick(){
        // 1获取vc
        let vc = UIStoryboard(name: "pop", bundle: nil).instantiateInitialViewController()
        // 2.1 设置代理
        vc?.transitioningDelegate = popoverAnimator
        // 2.2设置转场的样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    private lazy var popoverAnimator :PQPopverAnimation = {
        let pop = PQPopverAnimation()
        let width = UIScreen.mainScreen().bounds.width
        pop.presentFrame = CGRect(x: (width - width * 0.5) / 2.0, y: 56, width: width * 0.5, height: width * 0.6)
        pop.animaDuration = 0.4
        return pop
    }()
}



