//
//  PQUserInfoModel.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/8.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQUserInfoModel: NSObject {
    /// 用户ID
    var id: Int = 0
    /// 用户昵称
    var name :String?
    /// 用户头像地址
    var profile_image_url  : String?
    {
        didSet{
            if let urlStr = profile_image_url
            {
                imageURL = NSURL(string: urlStr)
            }
        }
    }
    /// 用户头像地址
    var imageURL : NSURL?
    
    /// 用户是否认证
    var verified :Bool = false
    /// 用户认证类型， -1 没有认证 0，认证用户 2 3 5企业认证 220 达人
    var verified_type : Int = -1{
        didSet{
            switch verified_type {
            case 0:
                verified_image = UIImage(named: "avatar_vip")
            case 2,3,5:
                verified_image = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verified_image = UIImage(named: "avatar_grassroot")
            default:
                verified_image = nil
            }
        }
    }
    /// 认证头像
    var verified_image : UIImage?
    
    var mbrank : Int = 0{
        didSet{
            if mbrank > 0 && mbrank < 7 {
                mbrankImage = UIImage(named: "common_icon_membership_level\(mbrank)")
            }
        }
    }
    var mbrankImage :UIImage?
    
    
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
