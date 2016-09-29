//
//  PQBaseTableVC.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/12.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit



class PQBaseTableVC: UITableViewController ,PQNotLoginViewDelegate{

    private lazy var visitor : PQNotLoginView = {
        let visitor = PQNotLoginView(frame: UIScreen.mainScreen().bounds)
        return visitor
    }()
    
    var isLogin :Bool = PQOauthInfo.userLogin()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLogin {
            view.addSubview(visitor)
            visitor.delegate = self
            
            //创建左右中间按钮
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PQBaseTableVC.registerButtonDidClick))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PQBaseTableVC.loginButtonDidClick))
        }
        tableView.separatorStyle = .None
    }
    
    

    //用于设置是否是主页
    func setVisitorIsIndex(isIndex : Bool,imageNamed : String , hiddenAll : Bool){
        visitor .setBackgroundImageWithIsIndex(isIndex, imageNamed: imageNamed,hiddenAll:hiddenAll)
    }
    
    //MARK - Visitor delegate
    //登录代理
    func loginButtonDidClick(){
        let vc = PQOAuthViewController()
        let nav = UINavigationController(rootViewController: vc)
        presentViewController(nav, animated: true, completion: nil)
    }
    //注册代理
    func registerButtonDidClick(){
        
    }
    //关注代理
    func concernButtonDidClick(){
        
    }
}
