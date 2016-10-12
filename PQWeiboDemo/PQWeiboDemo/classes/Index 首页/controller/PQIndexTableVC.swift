
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
        tableView.register(PQIndexTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
//        tableView.rowHeight = 200
//        tableView.estimatedRowHeight = 200
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        // 3、下载数据
        downloadData()
    }
    
    
    
    //通过通知来改变按钮图片
    @objc private func popMenuNotifaction(){
        navigatorCenter.isSelected = !navigatorCenter.isSelected
    }
    
    deinit{
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setVisitorIsIndex(isIndex: true, imageNamed: "visitordiscover_feed_image_house",hiddenAll:false)
        
        //登录了才显示
        if isLogin {
            //创建左右中间按钮
            navigationItem.leftBarButtonItem = UIBarButtonItem.createSelecedtButton(image: "navigationbar_friendattention", target: self, action: #selector(PQIndexTableVC.leftBtnClick))
            navigationItem.rightBarButtonItem = UIBarButtonItem.createSelecedtButton(image: "navigationbar_pop", target: self, action: #selector(PQIndexTableVC.rightBtnClick))
            navigationItem.titleView =  navigatorCenter
        }
    }
    
    // 创建一个数据源
    private var dataSource : TBDataSource?
    
    /**
     下载数据
     */
    private func downloadData(){
        
        if isLogin  {
            PQStatusesModel.loadData { (models, error) in
                if models != nil{
                    self.statuses = models
                }
            }
        }
        
    }
    
    /**
     监听通知
     */
    private func listenNoti(){
        NotificationCenter.default.addObserver(self, selector: #selector(PQIndexTableVC.popMenuNotifaction), name: NSNotification.Name(rawValue: popoverViewWillShow), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PQIndexTableVC.popMenuNotifaction), name: NSNotification.Name(rawValue: popoverViewWillClose), object: nil)
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
        vc?.modalPresentationStyle = UIModalPresentationStyle.custom
        present(vc!, animated: true, completion: nil)
    }
    
    //弹出视图
    private lazy var popoverAnimator :PQPopverAnimation = {
        let pop = PQPopverAnimation()
        let width = UIScreen.main
            .bounds.width
        pop.presentFrame = CGRect(x: (width - width * 0.5) / 2.0, y: 56, width: width * 0.5, height: width * 0.6)
        pop.animaDuration = 0.4
        return pop
    }()
    
    //中间导航栏按钮
    private lazy var navigatorCenter : PQDIYButton = PQDIYButton.createButton(dict: ["title":PQOauthInfo.loadAccoutInfo()!.name! as AnyObject,"image":"navigationbar_arrow_down" as AnyObject,"selected":"navigationbar_arrow_up" as AnyObject,"textColor":UIColor.lightGray], type: PQButtonLayoutType.LeftTextRightImage, target: self, selector: #selector(PQIndexTableVC.centerBtnClick))
    
    lazy var modalAnimation : PQModalAnimation = {
        let modal = PQModalAnimation(direction: PQAnimationDirection.bottom)
        modal.presentFrame.size.height = 305
        return modal
    }()
    
    
    //行高
    var cellRowHeight : [Int : Any] = Dictionary()
}

extension PQIndexTableVC{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! PQIndexTableViewCell
        cell.statuses = statuses![indexPath.row]
        cell.showMenu = { (cell : PQIndexCellTopView) -> Void in
            
            let vc = PQActionSheetVC.loadForStoryboard()
            vc.transitioningDelegate = self.modalAnimation
            vc.modalPresentationStyle = UIModalPresentationStyle.custom
            self.present(vc, animated: true, completion: nil)
        }
        return cell
    }
    
    // 缓存行高
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let statu = statuses![indexPath.row]
        
        // 先从字典里面获取 获取成功就返回
        if let rowHeight = cellRowHeight[statu.id] {
            print("从里面拿的 - \(rowHeight)")
            return rowHeight as! CGFloat
        }
        
        // 获取失败 自己计算一次 在返回前先存入字典 在返回行高
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! PQIndexTableViewCell
        let height = cell.rowHeight(statuses: statu)
        cellRowHeight[statu.id] = height
        print("自己计算的的 - \(height)")
        return height
        
    }
}





