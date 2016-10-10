//
//  PQFromRightAnimation.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/9.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQFromRightAnimation: PQAnimation {
    
    init(isShow : Bool , fromView : UIView ,toView : UIView,height : CGFloat) {
        super.init()
        self.toView = toView
        self.fromView = fromView
        self.isShow = isShow
        self.height = height
        
        // 默认是present
        toView.transform = CGAffineTransformMakeTranslation(UIScreen.mainScreen().bounds.width, 0)
        
        if isShow == false  {
            fromView.transform = CGAffineTransformMakeScale(0.95, 0.95)
            fromView.layer.transform = CATransform3DMakeTranslation(0, 0, -10)
        }
        
        startAnimation = {
            
            if self.isShow {
                self.toView.transform = CGAffineTransformIdentity
                self.fromView.transform = CGAffineTransformMakeScale(0.95, 0.95)
                self.fromView.layer.transform = CATransform3DMakeTranslation(0, 0, -10)
            }else{
                self.toView.transform = CGAffineTransformMakeTranslation(UIScreen.mainScreen().bounds.width, 0)
                self.fromView.layer.transform = CATransform3DIdentity
                self.fromView.transform = CGAffineTransformIdentity
            }
            
            
        }
        
    }
}
