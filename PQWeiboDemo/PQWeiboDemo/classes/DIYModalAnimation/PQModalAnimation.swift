//
//  PQModalAnimation.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/9.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit
/// 页面将要出现
public let PQModalAnimationWillShowKey = "popoverViewWillShowKey"
/// 页面将要消失
public let PQModalAnimationWillCloseKey = "popoverViewWillCloseKey"

class PQModalAnimation: NSObject, UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning {
    
    /// 记录当前是否展开
    var isPresent: Bool = false
    /// 显示视图的大小
    var presentFrame = CGRectZero
    
    var animaDuration : NSTimeInterval = 0.5
    
    var modalDirectionType : PQAnimationDirection = PQAnimationDirection.top
    
    var animations : PQAnimation?
    
    var preSentHeight : CGFloat = UIScreen.mainScreen().bounds.height
    
    override init() {
        super.init()
    }
    
    init(direction : PQAnimationDirection?) {
        super.init()
        modalDirectionType = direction ?? PQAnimationDirection.top
    }
    
    /**
     实现代理方法，告诉系统谁来负责转场动画
     
     - parameter presented:  被展现的视图
     - parameter presenting: 发起的视图
     - parameter source:     源
     
     - returns:
     */
//    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?{
//        let pc = PQModalShowSizeController(presentedViewController: presented, presentingViewController: presenting)
//        pc.presentFrame = presentFrame
//        return pc
//    }
    
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
        NSNotificationCenter.defaultCenter().postNotificationName(PQModalAnimationWillShowKey, object: nil)
        
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
        NSNotificationCenter.defaultCenter().postNotificationName(PQModalAnimationWillCloseKey, object: nil)
        return self
    }
    
}



// MARK: - 动画处理
extension PQModalAnimation{
    /**
     设置动画时长,默认0.5秒
     
     - parameter transitionContext: 上下文，里面保存了动画需要的所有参数
     
     - returns: 动画时长
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return animaDuration
    }
    
    
    
    
    /**
     告诉系统如何动画，消失、出现都会调用这个方法
     
     - parameter transitionContext: 上下文，保存了动画需要的所有参数
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
//        if isPresent {
//            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
////            toView?.bounds.size.height = 316
//            toView?.frame.origin.y = UIScreen.mainScreen().bounds.height
//            transitionContext.containerView()?.addSubview(toView!)
//            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { 
//                toView?.frame.origin.y = 400
//                }, completion: { (_) in
//                    transitionContext.completeTransition(true)
//            })
//        }
//        else{
//            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
//            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { 
//                fromView?.transform = CGAffineTransformMakeTranslation(0, UIScreen.mainScreen().bounds.height)
//                }, completion: { (_) in
//                    transitionContext.completeTransition(true)
//            })
//        }
        
        testAnimate(transitionContext)
    }
    
    private func testAnimate(transitionContext : UIViewControllerContextTransitioning){
        // 1、获取到要展现的视图
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey) ?? transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view
        // 2、把视图添加到容器上
        
        let fromView = (transitionContext.viewForKey(UITransitionContextFromViewKey) ?? transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view)?.snapshotViewAfterScreenUpdates(true)
        
//        transitionContext.containerView()?.addSubview(fromView!)
        if isPresent {
            transitionContext.containerView()?.addSubview(toView!)            
        }

        
        animations = PQAnimation.createAnimation(isPresent, direction: modalDirectionType, fromView: fromView!, toView: toView!, height : preSentHeight)
        
        // 4、执行动画
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations:animations!.startAnimation!
            
            , completion: { (_) in
                // 6、动画执行完成后一定要记得通知系统
                
                transitionContext.completeTransition(true)
                
                
        })
    }
}
