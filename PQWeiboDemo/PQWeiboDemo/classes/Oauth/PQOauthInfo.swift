//
//  PQOauthInfo.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/26.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQOauthInfo: NSObject ,NSCoding {
    /// string 	用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态，不能使用本返回值里的UID字段来做登录识别。
    var access_token :  String?
    
    ///  	access_token的生命周期，单位是秒数。
    var expires_in :    NSNumber?{
        didSet{
            expires_date = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
            print("过期时间 - \(expires_date)")
        }
    }
    
    
    /// 授权用户的UID，本字段只是为了方便开发者，减少一次user/show接口调用而返回的，第三方应用不能用此字段作为用户登录状态的识别，只有access_token才是用户授权的唯一票据。
    var uid :           String?
    
    /// 此项用于判断授权时间是否过期
    var expires_date :  NSDate?
    
    /// 用户大头像地址
    var avatar_large : String?
    
    /// 用户昵称
    var name : String?
    

    
    /**
     KVC赋值
     */
    init(dict : NSDictionary) {
        super.init()
        setValuesForKeysWithDictionary(dict as! [String : AnyObject])
    }
    
    /**
     防止未找到对应的属性出错
     */
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    
    func loadUserInfo(finished : (account: PQOauthInfo? , error : NSError?) -> Void){
        let url = "users/show.json"
        let params = ["access_token":access_token!,"uid":uid!]
        
        PQNetWorkManager.shareNetWorkManager().GET(url, parameters: params, success: { (_, JSON) in
            self.avatar_large = JSON!["avatar_large"] as? String
            self.name = JSON!["name"] as? String
            finished(account: self, error: nil)
            }) { (_, error) in
                print(error)
                finished(account: nil, error: error)
        }
    }
    
    /**
     用于判断用户是否登录
     */
    class func userLogin() -> Bool{
        return loadAccoutInfo() == nil ? false : true
    }

    /// 路径
    static let filePath = "account.plist".cacheDir()
    ///保存授权模型
    func saveAccountInfo(){
        print("用户信息地址:  \(PQOauthInfo.filePath)")
        NSKeyedArchiver.archiveRootObject(self, toFile: PQOauthInfo.filePath)
    }
    
    static var account : PQOauthInfo?
    class func loadAccoutInfo() -> PQOauthInfo?{
        // 判断是否存在对象了，如果存在则不去解归档
        if account != nil {
            return account
        }
        
        // 解归档
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? PQOauthInfo
        
        // 判断是否过期
        if account?.expires_date?.compare(NSDate()) == NSComparisonResult.OrderedAscending { //如果得到的是升序 表示已经过期
            // 2022-05-06 08：34：20  <  2022-05-07 12：11：30
            return nil
        }
        
        return account
    }
    
    /**
     Mark - NSCoding
     */
     ///归档
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(name , forKey: "name")
    }
     ///解归档
    required init?(coder aDecoder: NSCoder){
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }

    //打印对象
    override var description: String{
        let properties = ["access_token","expires_in","expires_date","uid","name","avatar_large"]
        let dict = self.dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
}