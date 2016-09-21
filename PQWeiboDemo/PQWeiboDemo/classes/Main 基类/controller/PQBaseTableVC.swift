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
    
    var isLogin :Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLogin {
            view.addSubview(visitor)
            visitor.delegate = self
        }
    }
    
    

    //用于设置是否是主页
    func setVisitorIsIndex(isIndex : Bool,imageNamed : String){
        visitor .setBackgroundImageWithIsIndex(isIndex, imageNamed: imageNamed)
    }
    
    //MARK - Visitor delegate
    //登录代理
    func loginButtonDidClick(){
        
    }
    //注册代理
    func registerButtonDidClick(){
        
    }
    //关注代理
    func concernButtonDidClick(){
        
    }
}
