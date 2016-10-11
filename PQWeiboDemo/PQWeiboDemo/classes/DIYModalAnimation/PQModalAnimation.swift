//
//  PQModalAnimation.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/9.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit
/// 页面将要出现
public let PQModalAnimationWillShowKey = "PQModalAnimationWillShowKey"
/// 页面将要消失
public let PQModalAnimationWillCloseKey = "PQModalAnimationWillCloseKey"

class PQModalAnimation: NSObject, UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning {
    
    /// 记录当前是否展开
    var isPresent: Bool = false
    /// 显示视图的大小
    var presentFrame = UIScreen.main.bounds
    
    /// 动画时长
    var animaDuration : TimeInterval = 0.5
    /// 动画方向
    var modalDirectionType : PQAnimationDirection = PQAnimationDirection.top
    
    /// 展示视图
    private var presented : UIViewController?
    
    /// 图层遮罩
    lazy var backView : UIView = {
     let back = UIView(frame: UIScreen.main.bounds)
        back.backgroundColor = UIColor(white: 0, alpha: 0.2)
        let tap = UITapGestureRecognizer(target: self, action: #selector(PQModalAnimation.dismiss))
        back.addGestureRecognizer(tap)
        return back
    }()
    
    /**
     dismiss
     */
    @objc private func dismiss(){
        presented?.dismiss(animated: true, completion: nil)
    }
    
    
    init(direction : PQAnimationDirection?) {
        super.init()
        modalDirectionType = direction ?? PQAnimationDirection.top
    }
    
    /**
     告诉系统谁来负责modal动画
     
     - parameter presented:  被展现的视图
     - parameter presenting: 发起的视图
     - parameter source:
     
     - returns: 谁来负责
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        self.presented = presented
        isPresent = true
        //发送将要显示通知
        NotificationCenter.default.post(name : NSNotification.Name(rawValue: PQModalAnimationWillShowKey), object: nil)
        
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PQModalAnimationWillCloseKey), object: nil)
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
    @objc(transitionDuration:) func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) ->
        TimeInterval{
        return animaDuration
    }
    
    /**
     告诉系统如何动画，消失、出现都会调用这个方法
     
     - parameter transitionContext: 上下文，保存了动画需要的所有参数
     */
    @objc(animateTransition:) func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        // 1、获取到要展现的视图
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) ?? transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view
        
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) ?? transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view
        
        // 2、把视图添加到容器上
        if isPresent {
            toView?.frame = presentFrame
            transitionContext.containerView.addSubview(backView)
            transitionContext.containerView.addSubview(toView!)
        }
        
        // 3、获取动画
        let animations = PQAnimation.createAnimation(isShow: isPresent, direction: modalDirectionType, fromView: fromView!, toView: toView!, frame : presentFrame)
        
        // 4、执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations:animations.startAnimation!,
            completion: { (_) in
                // 6、动画执行完成后一定要记得通知系统
                transitionContext.completeTransition(true)
        })
        
        // 消失
        if self.isPresent == false {
            UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
                self.backView.removeFromSuperview()
            }
        }
    }
    
}
