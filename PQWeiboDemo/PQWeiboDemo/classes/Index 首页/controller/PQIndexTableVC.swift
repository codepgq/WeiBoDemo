//
//  PQIndexTableVC.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/12.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQIndexTableVC: PQBaseTableVC {
    
    let cellIdentifier = "IndexTableVCCellKey"
    
    var statuses : [PQStatusesModel]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1、监听通知
        listenNoti()
        
        // 2、提前注册cell
        tableView.registerClass(PQIndexTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
//        tableView.rowHeight = 200
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // 3、下载数据
        downloadData()
    }
    
    
    
    //通过通知来改变按钮图片
    @objc private func popMenuNotifaction(){
        navigatorCenter.selected = !navigatorCenter.selected
    }
    
    deinit{
        //移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setVisitorIsIndex(true, imageNamed: "visitordiscover_feed_image_house",hiddenAll:false)
        
        //登录了才显示
        if isLogin {
            //创建左右中间按钮
            navigationItem.leftBarButtonItem = UIBarButtonItem.createSelecedtButton("navigationbar_friendattention", target: self, action: #selector(PQIndexTableVC.leftBtnClick))
            navigationItem.rightBarButtonItem = UIBarButtonItem.createSelecedtButton("navigationbar_pop", target: self, action: #selector(PQIndexTableVC.rightBtnClick))
            navigationItem.titleView =  navigatorCenter
        }
    }
    
    // 创建一个数据源
    private var dataSource : TBDataSource?
    
    /**
     下载数据
     */
    private func downloadData(){
        
        PQStatusesModel.loadData { (models, error) in
            if models != nil{
                self.statuses = models
            }
        }
        
    }
    
    /**
     监听通知
     */
    private func listenNoti(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PQIndexTableVC.popMenuNotifaction), name: popoverViewWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PQIndexTableVC.popMenuNotifaction), name: popoverViewWillClose, object: nil)
    }
    
    /**
     左按钮点击事件
     */
    @objc private func leftBtnClick(){
    }
    
    /**
     右按钮点击事件
     */
    @objc private func rightBtnClick(){
        let vc = UIStoryboard(name: "QRCode", bundle: nil).instantiateInitialViewController()
        navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    /**
     中间按钮点击事件
     */
    @objc private func centerBtnClick(){
        // 1获取vc
        let vc = UIStoryboard(name: "pop", bundle: nil).instantiateInitialViewController()
        // 2.1 设置代理
        vc?.transitioningDelegate = popoverAnimator
        // 2.2设置转场的样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    //弹出视图
    private lazy var popoverAnimator :PQPopverAnimation = {
        let pop = PQPopverAnimation()
        let width = UIScreen.mainScreen().bounds.width
        pop.presentFrame = CGRect(x: (width - width * 0.5) / 2.0, y: 56, width: width * 0.5, height: width * 0.6)
        pop.animaDuration = 0.4
        return pop
    }()
    
    //中间导航栏按钮
    private lazy var navigatorCenter : PQDIYButton = PQDIYButton.createButton(["title":PQOauthInfo.loadAccoutInfo()!.name!,"image":"navigationbar_arrow_down","selected":"navigationbar_arrow_up","textColor":UIColor.lightGrayColor()], type: PQButtonLayoutType.LeftTextRightImage, target: self, selector: #selector(PQIndexTableVC.centerBtnClick))
    
    private lazy var modalAnimation : PQModalAnimation = {
        let modal = PQModalAnimation(direction: PQAnimationDirection.bottom)
        modal.preSentHeight = 305
        return modal
    }()
    
}

extension PQIndexTableVC{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        presentViewController(ac, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PQIndexTableViewCell
        cell.oauthInfo = statuses![indexPath.row]
        cell.showMenu = { (cell : PQIndexTableViewCell) -> Void in
            
            let vc = PQActionSheetVC.loadForStoryboard()
            vc.transitioningDelegate = self.modalAnimation
            vc.modalPresentationStyle = UIModalPresentationStyle.Custom
            self.presentViewController(vc, animated: true, completion: nil)
        }
        return cell
    }
    
    
}





