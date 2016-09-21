//
//  PQLIRTButton.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/18.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

//L left
//I image
//R right
//T text
/// 左边是文字右边是图片的Button
class PQLIRTButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame = CGRect(x: 0, y: 0, width: (titleLabel?.bounds.width)!, height: (titleLabel?.bounds.height)!)
        setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        imageView?.frame = CGRect(x: (titleLabel?.bounds.width)!, y:( bounds.height - (imageView?.bounds.height)!) / 2.0, width: (imageView?.bounds.width)!, height: (imageView?.bounds.height)!)
    }
}
