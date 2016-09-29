//
//  PQLoginViewController.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/26.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit
import SVProgressHUD

class PQOAuthViewController: UIViewController,UIWebViewDelegate {
    
    private var webView : UIWebView = {
        let web = UIWebView(frame: UIScreen.mainScreen().bounds)
        return web
    }()
    /// app key
    let WB_App_ID = "822933555"
    let WB_App_Secret = "46e328943e0daab0fb7c458482d18f38"
    let WB_redirect_uri = "https://www.baidu.com/"
    
    // 1、把当前的View替换成为webView
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1、设置web代理 默认加载项
        setUpWebView()
        
        // 2、添加一个关闭按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: #selector(PQOAuthViewController.close))
        
        // 3、设置标题
        navigationItem.title = "使用微博登录"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    private func setUpWebView(){
        webView.delegate = self
        let url = NSURL.init(string: "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_ID)&redirect_uri=\(WB_redirect_uri)")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    
    @objc private func close(){
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension PQOAuthViewController {
    
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.showWithStatus("正在加载……")
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
//        print(request.URL?.absoluteString)
        
        let absoluteString = request.URL!.absoluteString
        //如果是回调页 并且授权成功就继续
        if !absoluteString.hasPrefix(WB_redirect_uri) {
            // 不是回调页就继续
            return true
        }
        
        //如果成功了表示点击了授权
        let codeStr = "code="
        if request.URL!.query!.hasPrefix(codeStr) {
            //这句就是先比较code=，然后从最后一个取出Qequest_Token
            let code = request.URL!.query?.substringFromIndex(codeStr.endIndex)
            
            //利用以及授权的RequestToken 换区 AccessToken
            loadAccessToken(code!)
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
        PQNetWorkManager.shareNetWorkManager().POST(url, parameters: parames, success: { (_, JSON) in
            print(JSON)
            
            let account = PQOauthInfo(dict: JSON as! [String:AnyObject])
            print(account)
            // 通过accessToken、uid去获取个人信息
            account.loadUserInfo({ (account, error) in
                if error == nil{
                    //把信息归档保存
                    account?.saveAccountInfo()
                    SVProgressHUD.showSuccessWithStatus("授权成功")
                    
                    // 去欢迎回来页面
                    NSNotificationCenter.defaultCenter().postNotificationName(PQChangeRootViewControllerKey, object: false)
                }
            })
            
        }) { (_, error) in
                
                print(error)
        }
    }
}
