//
//  PQNullTableVC.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/12.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQNullTableVC: UIViewController,PQMenuViewDelegate {
    
        init(){
            super.init(nibName: nil, bundle: nil)
        }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 1, alpha: 0.4)
        
        setupUI()
    }
    
    private func setupUI(){
        // 1、添加子视图
        view.addSubview(effectView)
        
        view.addSubview(weatherView)
        view.addSubview(adView)
        view.addSubview(menuView)
        view.addSubview(cancelBtn)
//        
        //2、布局子视图
        effectView.pq_fill(referView: view)
        weatherView.pq_AlignInner(type: pq_AlignType.TopLeft, referView: view, size: CGSize(width: 100, height: 80),offset:  CGPoint(x: 20, y: 74))
        adView.pq_AlignInner(type: pq_AlignType.TopRight, referView: view, size: CGSize(width: 120, height: 95), offset: CGPoint(x: -30, y: 74))
        cancelBtn.pq_AlignInner(type: .BottomCenter, referView: view, size: nil ,offset:  CGPoint(x: 0, y: -5))
        menuView.pq_AlignInner(type: .BottomCenter, referView:view, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4), offset: CGPoint(x: 0, y: -44))
    }
    
    
    
    //添加一个背景
    private lazy var effectView : UIVisualEffectView = {
        let effect = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
        return effect
    }()
    
    //天气
    private lazy var weatherView : PQWeatherView = PQWeatherView(frame : CGRect.zero)
    
    //广告
    private lazy var adView : UIImageView = UIImageView(image : UIImage(named: "ad"))
    
    //菜单
    private lazy var menuView : PQMenuView = {
        let menu = PQMenuView(frame: CGRect.zero)
        menu.delegate = self
        menu.backgroundColor = UIColor.clear
        return menu
    }()
    
    private lazy var cancelBtn : UIButton = UIButton.createBtnWithTitle(title: nil, imageNamed: "tabbar_compose_background_icon_close", selector: #selector(PQNullTableVC.cancelBtnClick), target: self)
    
    @objc private func cancelBtnClick(){
        dimsissToLastVC(title: nil)
    }
    
    @objc private func dimsissToLastVC(title : String?){
        dismiss(animated: true){
            if title != nil{
                print("title")
                
                
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue : ComposeNotificationKey), object: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.cancelBtnClick()
    }
    
    deinit {
        print("dealloc")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didSelectedCell(cell: menuCell ,indexPath : IndexPath) {
        dimsissToLastVC(title: "dfasd")
    }
    
}


