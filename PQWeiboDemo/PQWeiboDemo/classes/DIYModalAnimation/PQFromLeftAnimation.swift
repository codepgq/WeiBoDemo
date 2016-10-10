//
//  PQFromLeftAnimation.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/9.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQFromLeftAnimation: PQAnimation {
    
    init(isShow : Bool , fromView : UIView ,toView : UIView,frame : CGRect) {
        super.init()
        self.toView = toView
        self.fromView = fromView
        self.isShow = isShow
        self.viewFrame = frame
        
        // 默认是present
        if isShow {
            toView.transform = CGAffineTransformMakeTranslation(-UIScreen.mainScreen().bounds.width, 0)
        }
        
        startAnimation = {
            
            if self.isShow {
                self.toView.transform = CGAffineTransformMakeTranslation(-(UIScreen.mainScreen().bounds.width - self.viewFrame.width), 0)
                
                self.fromView.transform = CGAffineTransformMakeScale(0.95, 0.95)
                self.fromView.layer.transform = CATransform3DMakeTranslation(0, 0, -10)
            }else{
                self.fromView.transform = CGAffineTransformMakeTranslation(-UIScreen.mainScreen().bounds.width, 0)
            }
        }
        
    }
}
