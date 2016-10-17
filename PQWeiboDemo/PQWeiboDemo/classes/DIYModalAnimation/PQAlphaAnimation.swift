//
//  PQAlphaAnimation.swift
//  PQWeiboDemo
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQAlphaAnimation: PQAnimation {
    init(isShow : Bool , fromView : UIView ,toView : UIView,frame : CGRect) {
        super.init()
        self.toView = toView
        self.fromView = fromView
        self.isShow = isShow
        self.viewFrame = frame
        
        // 默认是present
        if isShow {
            toView.alpha = 0
        }
        
        startAnimation = {
            if self.isShow {
                toView.alpha = 1
            }else{
                fromView.alpha = 0
            }
        }
    }

}
