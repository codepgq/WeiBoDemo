//
//  PQStatusesModel.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/8.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQStatusesModel: NSObject {
    /// 创建时间
    var created_at :String?{
        didSet{
            if created_at != nil {
                let date = NSDate.stringToDateWithString(created_at!, formatter: "EEE MMM d HH:mm:ss Z yyyy")
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
            if let mStr = source where source != "" {
                let location = (mStr as NSString).rangeOfString(">").location + 1
                let length = (mStr as NSString).rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - location
                source = "来自:" + (mStr as NSString).substringWithRange(NSMakeRange(location, length))
            }
        }
    }
    /// 微博ID
    var id : Int = 0
    /// 配图数组
    var pic_urls: [[String:AnyObject]]?
    /// 保存当前所有配图的URL
    var storedPicURLS : [NSURL]?
    /// 爆粗当前微博所有配图“大图”的URL
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
    var reposts_count :Int = 0
    //评论数
    var comments_count :Int = 0
    //点赞数
    var attitudes_count :Int = 0
    
    ///用户信息
    var user : PQUserInfoModel?
    
    
    class func loadData(finished : (models : [PQStatusesModel]? , error : NSError?) -> Void){
        let url = "statuses/public_timeline.json"
        let params = ["access_token":PQOauthInfo.loadAccoutInfo()!.access_token!]
        PQNetWorkManager.shareNetWorkManager().GET(url, parameters: params, progress: nil, success: { (_, JSON) in
            print(JSON)
            
            // 取出statuses 对应的数组
            // 遍历数组，将字典转模型
            let list = JSON!["statuses"] as! [[String: AnyObject]]
            var models = [PQStatusesModel]()
            for dict in list{
                models.append(PQStatusesModel(dict: dict))
            }
            
            finished(models: models, error: nil)
            
            }) { (_, error) in
                finished(models: nil, error: error)
        }
    }
    
    
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        // 1、判断当前是否是在为user赋值
        if "user" == key {
            //解析用户信息
            user = PQUserInfoModel(dict: value as! [String : AnyObject])
            return
        }
        
        // 2、判断是否是转发微博，如果是就自己处理
        if "retweeted_status" == key{
            return
        }
        
        // 3、都不是，那就自己处理
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
}
