//
//  PQViewController.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/12.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //在appdelegate中设置了全局外观，所以这里可以不用设置了
//        tabBar.tintColor = UIColor.orangeColor()
        //添加controller
        addController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //创建一个button，并设置到中间的位置
        setUpButton()
    }
    
    lazy var addBtn :UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        
        button.setImage(UIImage(named:"tabbar_compose_background_icon_add"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named:"tabbar_compose_button"), forState: .Normal)
        
        button.addTarget(self, action: #selector(PQTabBarController.addBtnClick(_:)), forControlEvents: .TouchUpInside)
        
        return button
    }()
    
    @objc private func addBtnClick(btn:UIButton) {
        print("btn click")
    }
    
    //添加加号按钮
    private func setUpButton(){
        let width : CGFloat = UIScreen.mainScreen().bounds.width / CGFloat(viewControllers!.count)
        addBtn.frame = CGRect(x: 0, y: 0, width: width, height: 49)
        addBtn.frame = CGRectOffset(addBtn.frame, 2 * width , 0)
        tabBar.addSubview(addBtn)
    }
    
    //添加controller
    private func addController(){
        //得到json数据地址
        let path :String = NSBundle.mainBundle().pathForResource("JsonData.json", ofType: nil)!
        
        //判断地址存不存在
        if let jsonPath :String = path
        {
            //得到data
            let data = NSData(contentsOfFile: jsonPath)
            do {
                //转化为Json数据
                let dictArray = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                //获取命名空间
                let namespace : String = getNamespace()
                
                //遍历数组，动态创建类 这里要指定类型 as! [[String:String]]
                for dict in dictArray as! [[String:String]] {
                    //创建controller
                    let controller = stringToController(dict["controller"]!,nameSpace:namespace)
                    //添加controller
                    addViewControllerToTabBar(controller,imageNamed: dict["imageNamed"]!,title: dict["title"]!)
                }
                print("create for Network")
            }
            catch{
                //如果解析json数据出错了，从本地创建controller
                createLocalController()
                print("create for Network")
            }
        }
        else{//如果获取json数据失败了，从本地创建
            createLocalController()
            print("create for Network")
        }
    }
    
    ///获取命名空间
    private func getNamespace() -> String{
        /*
         动态创建类，需要用到namesapce，命名空间，也就是前缀
         */
        
        //获取namespace info.plist中获取
        let infoPath : String = NSBundle.mainBundle().pathForResource("Info.plist", ofType: nil)!
        //得到
        let infoDict : NSDictionary = NSDictionary(contentsOfFile: infoPath)!
        
        return infoDict["CFBundleName"] as! String
        
    }
    ///从本地创建controller
    private func createLocalController(){
        //从本地加载
        addViewControllerToTabBar(PQIndexTableVC(), imageNamed: "tabbar_home", title: "首页")
        addViewControllerToTabBar(PQMessageTableVC(), imageNamed: "tabbar_message_center", title: "消息")
        addViewControllerToTabBar(PQNullTableVC(), imageNamed: "", title: "")
        addViewControllerToTabBar(PQDiscoverTableVC(), imageNamed: "tabbar_discover", title: "发现")
        addViewControllerToTabBar(PQMeTableVC(), imageNamed: "tabbar_profile", title: "我")
        
    }
    
    ///把字符串转化为类
    private func stringToController(controller : String , nameSpace : String) -> UITableViewController{
        //动态创建类，一定要包括 "命名空间." 比如 "PQWeiboDemo."
        let cls : AnyClass =
            NSClassFromString(String(nameSpace + "." + controller))!
        //类型指定
        let controller = cls as! UITableViewController.Type
        //创建
        return controller.init()
    }
    
    ///添加controller到tabBarVC
    private func addViewControllerToTabBar(vc : UITableViewController , imageNamed : String, title : String){
        //创建对应的controller
        //给controller包装一个NavigationController
        let base = UINavigationController()
        //设置navigationItem.title 和 tabBarItem.title
        vc.title = title
        //设置图片
        vc.tabBarItem.image = UIImage(named: imageNamed)
        //设置选中图片
        vc.tabBarItem.selectedImage = UIImage(named: "\(imageNamed)_highlighted")
        //包装NavigationController
        base.addChildViewController(vc)
        //添加到TabBarViewController中
        addChildViewController(base)
    }
    
}
