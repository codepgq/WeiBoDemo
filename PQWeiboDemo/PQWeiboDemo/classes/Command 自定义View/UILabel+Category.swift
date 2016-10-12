//
//  UILabel+Category.swift
//  PQWeiboDemo
//
//  Created by Mac on 16/10/11.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

extension UILabel{
    /**
     快速创建label
     
     - parameter fontSize:  字体大小
     - parameter textColor: 字体颜色
     
     - returns: label
     */
    class func createLabelWithFontSize(fontSize : CGFloat, textColor : UIColor) -> UILabel{
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = textColor
        return label
    }
    
}
