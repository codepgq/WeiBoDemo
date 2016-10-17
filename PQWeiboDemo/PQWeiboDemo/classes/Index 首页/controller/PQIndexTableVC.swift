
//
//  PQIndexTableVC.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/12.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit


class PQIndexTableVC: PQBaseTableVC {
    // 数据源
    var statuses : [PQStatusesModel]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        // 1、监听通知
        listenNoti()
        
        // 2、提前注册cell
        tableView.register(PQIndexTableViewNormalCell.self, forCellReuseIdentifier: PQIndexCellIdentifier.normal.rawValue)
        tableView.register(PQIndexTableViewForwardCell.self, forCellReuseIdentifier: PQIndexCellIdentifier.forward.rawValue)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresh
        } else {
            // Fallback on earlier versions
            refreshControl = refresh
        }
        refresh.addTarget(self, action: #selector(downloadData), for: .valueChanged)
        
        // 3、下载数据
        if isLogin{
            downloadData()
        }
        navigationController?.navigationBar.isTranslucent = false
        newStatusLabel.isHidden = false
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
    
    /// 定义上拉刷新标志位
    var pullUpRefreshFlag = false
    /**
     下载数据
     */
    @objc  func downloadData(){
        
        var since_id = statuses?.first?.id ?? 0
        
        var max_id = 0
        
        if pullUpRefreshFlag {
            since_id = 0
            max_id = statuses?.last?.id ?? 0
            pullUpRefreshFlag = false //还原标志位
        }
        
        
        PQStatusesModel.loadData(since_id : since_id, max_id : max_id) { (models, error) in
            //判断数据源是否存在
            guard let list = models else { return }
            //判断是否是下啦刷新加载的数据
            if  since_id > 0  {
                self.statuses = list + self.statuses!
                self.newStatusLabel.updateWithCount(list.count)
                self.newStatusLabel.showStatusLabel()
            }else if max_id > 0{
                //上拉刷新
                self.statuses = self.statuses! + models!
            } else{
                // 赋值数据
                self.statuses = list
            }
        }
    }
    
    /**
     监听通知
     */
    private func listenNoti(){
        // 下拉菜单通知
        NotificationCenter.default.addObserver(self, selector: #selector(PQIndexTableVC.popMenuNotifaction), name: NSNotification.Name(rawValue: popoverViewWillShow), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PQIndexTableVC.popMenuNotifaction), name: NSNotification.Name(rawValue: popoverViewWillClose), object: nil)
        // 显示图片浏览器通知
        NotificationCenter.default.addObserver(self, selector: #selector(PQIndexTableVC.showImageBroserNotifation(noti:)), name: Notification.Name(rawValue : ShowImageBrowserNotification.notiName.rawValue), object: nil)
    }
    
    //通过通知来改变按钮图片
    @objc private func popMenuNotifaction(){
        navigatorCenter.isSelected = !navigatorCenter.isSelected
    }
    
    // 显示图片浏览器
    @objc private func showImageBroserNotifation(noti : Notification){
//        print(noti.userInfo)
        
        guard let index = noti.userInfo?[ShowImageBrowserNotification.userInfo_indexPath.rawValue]  as? IndexPath else {
            print("index is nil")
            return
        }
        guard let urls = noti.userInfo?[ShowImageBrowserNotification.userInfo_URLS.rawValue] as? Array<URL> else {
            print("urls is nil")
            return
        }
        let browser = PQImageBroserViewController(currenIndex: index, ulrs: urls)
        present(browser, animated: true, completion: nil)
        
    }
    
    deinit{
        //移除通知
        NotificationCenter.default.removeObserver(self)
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
    
    // 自定义下拉刷新菜单
    lazy var refresh : PQIndexRereshControl = PQIndexRereshControl()
    
    private lazy var newStatusLabel  : PQNewStatusView = {
        let view = PQNewStatusView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        self.navigationController?.navigationBar.insertSubview(view, at: 0)
        self.navigationController?.navigationBar.insertSubview(view, at: 0)
        return view
    }()
    
    //行高
    var cellRowHeight : [Int : Any] = Dictionary()
    
    //当发生内存警告时，删除所有的缓存行高
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        cellRowHeight.removeAll()
    }
}

// -------  tableview datasource
extension PQIndexTableVC{
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.refresh.endRefreshing()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refresh.isRatationFlag && !refresh.loadingFlage {
            refresh.beginRefreshing()
            downloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // model
        let status = statuses![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PQIndexCellIdentifier.cellID(status: status), for: indexPath as IndexPath) as! PQIndexTableViewCell
        cell.statuses = status
        cell.selectionStyle = .none
        
        let count = statuses?.count ?? 0
        if indexPath.row == count - 1 {
            print("上拉加载")
            pullUpRefreshFlag = true
            downloadData()
        }
        
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
            return rowHeight as! CGFloat
        }
        // 获取失败 自己计算一次 在返回前先存入字典 在返回行高
        let cell = tableView.dequeueReusableCell(withIdentifier: PQIndexCellIdentifier.cellID(status: statu)) as! PQIndexTableViewCell
        let height = cell.rowHeight(statuses: statu)
        cellRowHeight[statu.id] = height
        return height
        
    }
}





