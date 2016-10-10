//
//  PQAnimation.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/9.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

enum PQAnimationDirection {
    case left
    case right
    case top
    case bottom
}

class PQAnimation: NSObject {
    
    var startAnimation : (()->())?
    var fromView : UIView = UIView()
    var toView : UIView = UIView()
    var isShow : Bool = true
    var viewFrame : CGRect = CGRectZero
    class func createAnimation(isShow : Bool , direction : PQAnimationDirection , fromView : UIView ,toView : UIView,frame : CGRect) -> PQAnimation {
        
        switch direction {
        case .left:
            return PQFromLeftAnimation(isShow: isShow,fromView:  fromView, toView: toView,frame : height)
        case .right:
            return PQFromRightAnimation(isShow: isShow,fromView:  fromView, toView: toView,frame : height)
        case .top:
            return PQFromTopAnimation(isShow: isShow,fromView:  fromView, toView: toView,frame : height)
        default:
            return PQFromBottomAnimation(isShow: isShow,fromView:  fromView, toView: toView,frame : height)
        }
    }
}
