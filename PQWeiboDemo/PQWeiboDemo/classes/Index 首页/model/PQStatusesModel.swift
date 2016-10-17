//
//  PQStatusesModel.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/8.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit
import SDWebImage

class PQStatusesModel: NSObject {
    /// 创建时间
    var created_at :String?{
        didSet{
            if created_at != nil {
                let date = NSDate.stringToDateWithString(string: created_at!, formatter: "EEE MMM d HH:mm:ss Z yyyy")
                created_at = date.descDate
            }
            else{
                created_at = "未知的时间"
            }
            
        }
    }
    /// 微博信息内容
    var text : String?
    /// 微博来源
    var source : String?
    {
        didSet{
            //range(of searchString: String, options mask: NSString.CompareOptions = []
            //NSString.range(option)
            if let mStr = source , source != "" {
                let location = (mStr as NSString).range(of: ">").location + 1
                let length = (mStr as NSString).range(of : "<", options: .backwards).location - location
                source = "来自:" + (mStr as NSString).substring(with: NSMakeRange(location, length))
            }
        }
    }
    /// 微博ID
    var id : Int = 0
    /// 配图数组
    var pic_urls: [[String:AnyObject]]?{
        didSet{
            storedPicURLS = [NSURL]()
            //大图
            storedLargePicURLS = [NSURL]()
            for dict in pic_urls!{
                
                if let urlStr = dict["thumbnail_pic"] as? NSString{
                    storedPicURLS?.append(NSURL(string: dict["thumbnail_pic"] as! String)!)
                    
                    // 2.处理大图
                    let largeURLStr =  urlStr.replacingOccurrences(of: "thumbnail", with: "large")
                    storedLargePicURLS!.append(NSURL(string: largeURLStr)!)
                }
                
            }
        }
    }
    /// 保存当前所有配图的URL
    var storedPicURLS : [NSURL]?
    /// 保存当前微博所有配图“大图”的URL
    var storedLargePicURLS:[NSURL]?
    /// 转发微博
    var retweeted_status : PQStatusesModel?
    // 如果有转发, 原创就没有配图
    /// 定义一个计算属性, 用于返回原创获取转发配图的URL数组
    var pictureURLS:[NSURL]?
    {
        return retweeted_status != nil ? retweeted_status?.storedPicURLS : storedPicURLS
    }
    /// 定义一个计算属性, 用于返回原创或者转发配图的大图URL数组
    var LargePictureURLS:[NSURL]?
    {
        return retweeted_status != nil ? retweeted_status?.storedLargePicURLS : storedLargePicURLS
    }
    //转发数
    var reposts_count :Int = 0{
        didSet{
            if reposts_count > 0 {
                repostsString = String(reposts_count)
            }
        }
    }
    //转发
    var repostsString : String = "转发"
    
    //评论数
    var comments_count :Int = 0{
        didSet{
            if comments_count > 0 {
                commentsString = String(comments_count)
            }
        }
    }
    var commentsString : String = "评论"
    //点赞数
    var attitudes_count :Int = 0 {
        didSet{
            if attitudes_count > 0 {
                attitudesString = String(attitudes_count)
            }
        }
    }
    var attitudesString : String = "点赞"
    ///用户信息
    var user : PQUserInfoModel?
    
    //是否显示气球
    var is_show_bulletin : Int = 0 {
        didSet{
            if is_show_bulletin > 0 {
                isHiddenBalloon = false
            }
        }
    }
    
    var isHiddenBalloon : Bool = true
    
    class func loadData(since_id : Int , max_id : Int , finished : @escaping (_ models : [PQStatusesModel]? , _ error : NSError?) -> Void){
        let url = "2/statuses/home_timeline.json"
        var params = ["access_token":PQOauthInfo.loadAccoutInfo()!.access_token!]
        if since_id > 0 {
            params["since_id"] = "\(since_id)"
        }
        
        if max_id > 0 {
            params["max_id"] = "\(max_id - 1)"
        }
        
        print("开始请求数据啦")
        
        PQNetWorkManager.shareNetWorkManager().get(url, parameters: params, progress: nil, success: { (_, JSON) in
//            print(JSON)
            
            // 取出statuses 对应的数组
            // 遍历数组，将字典转模型
            let list = (JSON as! [String : Any] ) ["statuses"] as! [[String: Any]]
            var models = [PQStatusesModel]()
            for dict in list{
                models.append(PQStatusesModel(dict: dict))
            }
            
            //缓存所有配图
            loadAllImageCaches(list: models, finished: finished)
            
            //            finished(models: models, error: nil)
            }, failure: { (_, error) in
                print("网络出错啦！！！！呜啦啦啦")
        })
    }
    
    
    class func loadAllImageCaches(list:[PQStatusesModel],finished : @escaping (_
        models : [PQStatusesModel]? , _ error : NSError?) -> Void){
        
        if list.count == 0 {
            finished(list,nil)
            return
        }
        
        print("缓存地址".cacheDir())
        print(PQOauthInfo.loadAccoutInfo())
        
        //创建一个组用于保证所有的图片下载完成之后通知界面
        let group = DispatchGroup()
        print("开始缓存图片")
        // 1、缓存图片
        for statuses in list{
            //1.1  判断当前图片数组是否为空
            guard let urls = statuses.pictureURLS else {
                continue
            }
            
            // 2、缓存图片
            for url in urls {
                // 2.1 把任务加入线程组中
//                print("开始缓存")
                group.enter()
                // 2.2 开始下载
                SDWebImageManager.shared().downloadImage(with: url as URL!, options: SDWebImageOptions(rawValue:0), progress: nil, completed: { (_, _, _, _, _) in
                    // 2.3 下载完成后离开组
                    group.leave()
                })
            }
        }
        // 3、当组内所有图片缓存完成就会通知
       group.notify(queue: DispatchQueue.main) {
            print("缓存图片OK")
            finished(list,nil)
        }
        
    }
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        // 1、判断当前是否是在为user赋值
        if "user" == key {
            //解析用户信息
            user = PQUserInfoModel(dict: value as! [String : AnyObject])
            return
        }
        
        // 2、判断是否是转发微博，如果是就自己处理
        if "retweeted_status" == key{
            retweeted_status = PQStatusesModel(dict: value as! Dictionary)
            
            return
        }
        
        // 3、都不是，那就自己处理
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
