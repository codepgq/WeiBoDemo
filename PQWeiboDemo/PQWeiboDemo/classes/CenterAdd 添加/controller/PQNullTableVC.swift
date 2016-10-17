//
//  PQNullTableVC.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/12.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQNullTableVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = PQUtil.randomColor()
        
        setupUI()
    }
    
    private func setupUI(){
        // 1、添加子视图
        view.addSubview(adView)
        view.addSubview(cancelBtn)
        
        //2、布局子视图
        adView.pq_AlignInner(type: pq_AlignType.TopLeft, referView: view, size: CGSize(width: PQUtil.scrrenWith() - 20, height: PQUtil.screenHeight() * 0.3), offset:  CGPoint(x: 10, y: 40))
        cancelBtn.pq_AlignInner(type: .BottomCenter, referView: view, size: nil ,offset:  CGPoint(x: 0, y: -5))
        
    }
    
    private lazy var adView : UIImageView = {
        let ad = UIImageView(image : UIImage(named: "compose_emotion_table_send_normal"))
        let adClose = UIButton.createBtnWithTitle(title: nil, imageNamed: "tabbar_compose_background_icon_close", selector: #selector(PQNullTableVC.adClose), target: self)
        ad.addSubview(adClose)
        adClose.pq_AlignInner(type: .TopRight, referView: ad, size: CGSize(width: 30, height: 30), offset: CGPoint(x: -10, y: -10))
        return ad
    }()
    
    @objc private func adClose(){
        adView.removeFromSuperview()
    }
    
    private lazy var cancelBtn : UIButton = UIButton.createBtnWithTitle(title: nil, imageNamed: "tabbar_compose_background_icon_close", selector: #selector(PQNullTableVC.cancelBtnClick), target: self)
    
    @objc private func cancelBtnClick(){
        dismiss(animated: true, completion: nil)
    }
    
}


