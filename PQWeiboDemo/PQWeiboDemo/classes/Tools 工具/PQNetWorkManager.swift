//
//  PQNetWorkManager.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/26.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit
import AFNetworking

class PQNetWorkManager: AFHTTPSessionManager {
    
    static let tools : PQNetWorkManager = {
        let url = NSURL(string: "https://api.weibo.com/")
        let t = PQNetWorkManager(baseURL:url as URL?)
        
        // 设置数据能访问的类型
        t.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain","text/html") as? Set<String>
        return t
    }()
    
    class func shareNetWorkManager() -> PQNetWorkManager{
        return tools
    }
}
