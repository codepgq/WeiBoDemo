//
//  PQIndexRereshControl.swift
//  PQWeiboDemo
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQIndexRereshControl: UIRefreshControl {
    
    override init() {
        super.init()
        
        setUpUI()
    }
    
    //初始化UI
    private func setUpUI(){
        
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
        
        addSubview(refreshView)
        
        refreshView.pq_AlignInner(type: .Center, referView: self, size: CGSize(width: 125, height: 50))
    }
    
    // 翻转
    var isRatationFlag = false
    
    var loadingFlage = false
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print(frame.origin.y)
        
        let offsetY = frame.origin.y
        
        if offsetY >= 0 {
            return
        }
        
        if isRefreshing && !loadingFlage {
            print("展示加载视图")
            loadingFlage = !loadingFlage
            refreshView.startLoadingAnimate()
        }
        
        if offsetY >= -50 && isRatationFlag {
            print("翻转回来")
            isRatationFlag = false
            refreshView.rotationIconDown(rotation: isRatationFlag)
        }else if offsetY < -50 && !isRatationFlag{
            print("翻转")
            isRatationFlag = true
            refreshView.rotationIconDown(rotation: isRatationFlag)
        }
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        
        loadingFlage = false
        refreshView.stopLoadingAnimate()
    }
    
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
    
    private lazy var refreshView : IndexRefreshView = IndexRefreshView.loadForXib()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class IndexRefreshView: UIView {

    class func loadForXib() -> IndexRefreshView {
        return Bundle.main.loadNibNamed("IndexRefreshView", owner: nil, options: nil)?.last as! IndexRefreshView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadingView.isHidden = true
    }
    
    func rotationIconDown(rotation : Bool) {
        var angle : CGFloat = CGFloat(M_PI)
        angle += rotation ? -0.01 : 0.01
        titleLabel.text = !rotation ? "下拉刷新" : "释放刷新"
        UIView.animate(withDuration: 0.25) {
            self.iconView.transform = self.iconView.transform.rotated(by: CGFloat(angle))
        }
    }
    
    func startLoadingAnimate(){
        //显示界面
        loadingView.isHidden = false
        
        // 转圈动画
        let baseAnimation = CABasicAnimation(keyPath: "transform.rotation")
        //360°
        baseAnimation.toValue = M_PI * 2
        baseAnimation.repeatCount = MAXFLOAT
        baseAnimation.duration = 1
        baseAnimation.isRemovedOnCompletion = false
        
        loadIconView.layer.add(baseAnimation, forKey: nil)
    }
    
    func stopLoadingAnimate(){
        //显示界面
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.25) {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: { 
                self.loadingView.isHidden = true
                self.loadIconView.layer.removeAllAnimations()
            })
        }
    }
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadIconView: UIImageView!
}
