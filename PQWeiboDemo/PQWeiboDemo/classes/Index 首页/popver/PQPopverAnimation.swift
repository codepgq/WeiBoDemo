//
//  PQPopverAnimation.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/19.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

//通知 key
public let popoverViewWillShow = "popoverViewWillShowKey"
public let popoverViewWillClose = "popoverViewWillCloseKey"

class PQPopverAnimation: NSObject ,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning{
    
    /// 记录当前是否展开
    var isPresent: Bool = false
    /// 定义属性保存菜单大小
    var presentFrame = CGRect.zero
    
    var animaDuration : TimeInterval = 0.5
    
    /**
     实现代理方法，告诉系统谁来负责转场动画
     
     - parameter presented:  被展现的视图
     - parameter presenting: 发起的视图
     - parameter source:     源
     
     - returns:
     */
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?{
        let pc = PQPopverPresentationController(presentedViewController: presented, presenting: presenting)
        pc.presentFrame = presentFrame
        return pc
    }
    
    /**
     告诉系统谁来负责modal动画
     
     - parameter presented:  被展现的视图
     - parameter presenting: 发起的视图
     - parameter source:
     
     - returns: 谁来负责
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        
        isPresent = true
        //发送将要显示通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: popoverViewWillShow), object: nil)
        
        return self
    }
    
    /**
     谁来负责dissmiss动画
     
     - parameter dismissed: 被关闭的视图
     
     - returns: 谁来负责
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        
        isPresent = false
        //发送将要消失通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: popoverViewWillShow), object: nil)
        return self
    }
    
}



// MARK: - 动画处理
extension PQPopverAnimation{
    /**
     设置动画时长,默认0.5秒
     
     - parameter transitionContext: 上下文，里面保存了动画需要的所有参数
     
     - returns: 动画时长
     */
    @objc(transitionDuration:) func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return animaDuration
    }
    
    
    
    
    /**
     告诉系统如何动画，消失、出现都会调用这个方法
     
     - parameter transitionContext: 上下文，保存了动画需要的所有参数
     */
    @objc(animateTransition:) func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        if isPresent {
            // 1、获取到要展现的视图
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            toView?.transform = CGAffineTransform(scaleX: 1.0, y: 0)
            
            // 2、把视图添加到容器上
            transitionContext.containerView.addSubview(toView!)
            
            // 3、设置锚点
            toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            // 4、执行动画
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                // 5、设置动画
                toView?.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    // 6、动画执行完成后一定要记得通知系统
                    
                    transitionContext.completeTransition(true)
            })
            
        }
        else{
            
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext),  delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                fromView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.000001)
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
            })
        }
    }
}
