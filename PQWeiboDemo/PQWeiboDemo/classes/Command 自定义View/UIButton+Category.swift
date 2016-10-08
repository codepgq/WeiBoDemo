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
        button.setImage(UIImage(named : imageNamed), forState: .Normal)
        button.setTitle(title, forState: .Normal)
        button.addTarget(target, action: selector, forControlEvents: .TouchUpInside)
        return button
    }
}
