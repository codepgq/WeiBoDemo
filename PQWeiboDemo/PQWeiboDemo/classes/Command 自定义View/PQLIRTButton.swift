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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: .Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: .Selected)
        sizeToFit()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        titleLabel?.frame = CGRect(x: 0, y: 0, width: (titleLabel?.bounds.width)!, height: (titleLabel?.bounds.height)!)
//        setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
//        imageView?.frame = CGRect(x: (titleLabel?.bounds.width)!, y:( bounds.height - (imageView?.bounds.height)!) / 2.0, width: (imageView?.bounds.width)!, height: (imageView?.bounds.height)!)
//    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.size.width
    }
}
