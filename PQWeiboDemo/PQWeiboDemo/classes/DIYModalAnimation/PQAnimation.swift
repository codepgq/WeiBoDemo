//
//  PQAnimation.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/9.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit
// 从哪边开始
enum PQAnimationDirection {
    case left
    case right
    case top
    case bottom
}

class PQAnimation: NSObject {
    /// 动画闭包代码
    var startAnimation : (()->())?
    var fromView : UIView = UIView()
    var toView : UIView = UIView()
    /// 是不是present
    var isShow : Bool = true
    /// 大小
    var viewFrame : CGRect = CGRect.zero
    
    class func createAnimation(isShow : Bool , direction : PQAnimationDirection , fromView : UIView ,toView : UIView,frame : CGRect) -> PQAnimation {
        
        switch direction {
        case .left:
            return PQFromLeftAnimation(isShow: isShow,fromView:  fromView, toView: toView,frame : frame)
        case .right:
            return PQFromRightAnimation(isShow: isShow,fromView:  fromView, toView: toView,frame : frame)
        case .top:
            return PQFromTopAnimation(isShow: isShow,fromView:  fromView, toView: toView,frame : frame)
        default:
            return PQFromBottomAnimation(isShow: isShow,fromView:  fromView, toView: toView,frame : frame)
        }
    }
}
