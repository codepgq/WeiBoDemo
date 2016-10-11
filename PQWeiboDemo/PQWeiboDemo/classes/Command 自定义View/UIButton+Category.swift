
//
//  UIButton+Category.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/8.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit



extension UIButton{

   
    /**
     快速创建一个按钮
     
     - parameter title:      标题
     - parameter imageNamed: 图片名称
     - parameter selector:   方法
     
     - returns: 按钮
     */
    class func createBtnWithTitle(title : String? , imageNamed : String,selector : Selector,target :AnyObject ) -> UIButton{
        let button = UIButton();
        button.setImage(UIImage(named : imageNamed), for: .normal)
        button.setTitle(title, for: .normal)
        button.addTarget(target, action: selector, for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        return button
    }
}
