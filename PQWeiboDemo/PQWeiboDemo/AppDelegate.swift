//
//  AppDelegate.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/12.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

//更换rootViewController通知
let PQChangeRootViewControllerKey = "PQChangeRootViewControllerKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        // 设置导航条和工具条的外观
        // 因为外观一旦设置全局有效, 所以应该在程序一进来就设置
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        
        //添加通知
        // 谁来监听 监听到调用的方法 监听啥名字的 谁发送的
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.changeRootController(_:)), name: PQChangeRootViewControllerKey, object: nil)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        window?.backgroundColor = UIColor.whiteColor()
        
        window?.rootViewController = showController()
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    //移除监听
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //返回对应的Controller
    private func showController() -> UIViewController{
        //如果用户没有登录就返回未登录界面
        if !PQOauthInfo.userLogin() {
            return PQTabBarController()
        }
        else{
            // 判断时候有新版本，如果有返回新特性界面
            if isHasNewFeature() {
                return PQNewFeatureCollectionViewController()
            }
            // 如果没有返回欢迎界面
            return PQWelComeViewController()
        }
    }
    
    //判断有没有新版本
    private let appVersion = "CFBundleShortVersionString"
    private func isHasNewFeature() -> Bool{
        // 1、获取当前的版本
        let currentVersion = NSBundle.mainBundle().infoDictionary![appVersion]! as! String
        
        // 2、从本地加载版本信息
        var localVersion = NSUserDefaults.standardUserDefaults().valueForKey(appVersion) as? String
        if localVersion == nil {
            localVersion = ""
        }
        
        // 3、比较版本信息
        // 1.1.1  1.1.0 降序
        if currentVersion.compare(localVersion!) == NSComparisonResult.OrderedDescending {
            // 4、更新版本
            NSUserDefaults.standardUserDefaults().setValue(currentVersion, forKey: appVersion)
            //发现新版本了 需要更新
            return true
        }
        //没有新版本
        return false
    }
    
    //根据通知消息判断，如果是true则显示主页，否则就显示欢迎回来界面
    @objc private func changeRootController(noti : NSNotification){
        if (noti.object as! Bool) == true {
            window?.rootViewController = PQTabBarController()
        }
        else{
            window?.rootViewController = PQWelComeViewController()
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

