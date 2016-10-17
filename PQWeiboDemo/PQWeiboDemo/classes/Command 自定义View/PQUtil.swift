//
//  PQUtil.swift
//  PQWeiboDemo
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQUtil: NSObject {
    // 获取系统默认宽度
    class func scrrenWith() -> CGFloat{
        return UIScreen.main.bounds.width
    }
    // 获取系统默认高度
    class  func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    //获取系统默认的bounds
    class  func screenBounds() -> CGRect{
        return UIScreen.main.bounds
    }
    
    class func randomColor() -> UIColor{
        return UIColor(red: randomNum(), green: randomNum(), blue: randomNum(), alpha: 1.0)
    }
    
    class func randomNum() -> CGFloat {
        return CGFloat(arc4random_uniform(256)) / CGFloat(255)
    }
}


extension UIView {
    var height : CGFloat {
       return frame.size.height
    }
    
    var width : CGFloat {
        return frame.size.width
    }
    
    var x : CGFloat {
        return frame.origin.x
    }
    
    var y : CGFloat {
        return frame.origin.y
    }
}
