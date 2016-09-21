//
//  PQButtonCategory.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/18.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    /**
     快速创建一个一个带有选中效果的barbutton
     
     - parameter image:  默认图片，选中图片在默认图片后面加上 “_highlighted”
     - parameter target: target
     - parameter action: 方法
     
     - returns: barButtonItem
     */
    class func createSelecedtButton(image: String!,target: AnyObject?, action: Selector) -> UIBarButtonItem{
        //创建一个按钮
        let button = UIButton()
        //设置点击和默认图片
        button.setImage(UIImage(named: image!), forState: .Normal)
        button.setImage(UIImage(named: String(image + "_highlighted")), forState: .Highlighted)
        //设置点击事件
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        button.sizeToFit()
        //返回barbutton
        return UIBarButtonItem(customView: button)
    }
}
