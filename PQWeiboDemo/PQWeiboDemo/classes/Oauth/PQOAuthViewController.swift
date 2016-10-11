//
//  PQLoginViewController.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/26.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class PQOAuthViewController: UIViewController,UIWebViewDelegate {
    
    private var webView : UIWebView = {
        let web = UIWebView(frame: UIScreen.main.bounds)
        return web
    }()
    
//    private lazy var webView : WKWebView = {
//        let web = WKWebView(frame: UIScreen.main.bounds)
//        web.uiDelegate = self
//        return web
//    }()
    
    /// app key
    let WB_App_ID = "822933555"
    let WB_App_Secret = "46e328943e0daab0fb7c458482d18f38"
    let WB_redirect_uri = "https://www.baidu.com/"
    
    // 1、把当前的View替换成为webView
    override func loadView() {
        webView.delegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1、设置web代理 默认加载项
        setUpWebView()
        
        // 2、添加一个关闭按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(PQOAuthViewController.close))
        
        // 3、设置标题
        navigationItem.title = "使用微博登录"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    private func setUpWebView(){
//        webView.delegate = self
        let url = NSURL.init(string: "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_ID)&redirect_uri=\(WB_redirect_uri)")
        let request = NSURLRequest(url: url! as URL)
        webView.loadRequest(request as URLRequest)
    }
    
    
    @objc func close(){
        dismiss(animated: true, completion: nil)
    }
    
    
    deinit {
        print("退出了当前页面")
    }
}

extension PQOAuthViewController {
    
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show(withStatus: "正在加载……")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    // 加载失败
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        close()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 这里做跳转处理
        print(request.url?.absoluteString)
        
        let absoluteString = request.url!.absoluteString
        //如果是回调页 并且授权成功就继续
        if !absoluteString.hasPrefix(WB_redirect_uri) {
            // 不是回调页就继续
            return true
        }
        
        //如果成功了表示点击了授权
        let codeStr = "code="
        if request.url!.query!.hasPrefix(codeStr) {
            //这句就是先比较code=，然后从最后一个取出Qequest_Token
            let code = request.url!.query?.substring(to: codeStr.endIndex)
            
            //利用以及授权的RequestToken 换区 AccessToken
            loadAccessToken(code: code!)
        }
        else{//点击取消授权了
            close()
        }
        return true
    }
    
    
    // 用以及授权的RequestToken换取AccessToken
    private func loadAccessToken(code :String){
        // 1、定义路径
        let url = "oauth2/access_token"
        
        // 2、包装参数
        let parames = ["client_id":WB_App_ID,"client_secret":WB_App_Secret,"grant_type":"authorization_code","code":code,"redirect_uri":WB_redirect_uri]

        // 3、发送请求
        PQNetWorkManager.shareNetWorkManager().post(url, parameters: parames, success: { (_, JSON) in
            print(JSON)
            
            let account = PQOauthInfo(dict: JSON as! [String:AnyObject] as NSDictionary)
            print(account)
            // 通过accessToken、uid去获取个人信息
            account.loadUserInfo(finished: { (account, error) in
                if error == nil{
                    //把信息归档保存
                    account?.saveAccountInfo()
                    SVProgressHUD.showSuccess(withStatus: "授权成功")
                    
                    // 去欢迎回来页面
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: PQChangeRootViewControllerKey), object: false)
                }
            })
            
        }) { (_, error) in
                
                print(error)
        }
    }
}
