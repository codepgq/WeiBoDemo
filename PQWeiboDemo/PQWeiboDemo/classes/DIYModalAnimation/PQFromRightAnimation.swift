//
//  PQFromRightAnimation.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/9.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQFromRightAnimation: PQAnimation {
    
    init(isShow : Bool , fromView : UIView ,toView : UIView,frame : CGRect) {
        super.init()
        self.toView = toView
        self.fromView = fromView
        self.isShow = isShow
        self.viewFrame = frame
        
        // 默认是present
        if isShow {
            toView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        }
        
        startAnimation = {
            
            if self.isShow {
                self.toView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width - self.viewFrame.width, y: 0)
                
                self.fromView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.fromView.layer.transform = CATransform3DMakeTranslation(0, 0, -10)
            }else{
                self.fromView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
            }
        }
        
    }
}
