//
//  PQStatuesDao.swift
//  PQWeiboDemo
//
//  Created by Mac on 16/12/17.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQStatuesDao: NSObject {
    
    class func loadData(since_id : Int , max_id : Int , finished : @escaping (_ models : [[String: AnyObject]]? , _ error : NSError?) -> Void){
        //1、从本地拿数据
        loadCacheStatuses(since_id: since_id, max_id: max_id) { (localDatas) in
            //2、判断能否拿到数据
            if !localDatas.isEmpty{
                print("从数据库中取出数据")
                finished(localDatas,nil)
                return
            }
            
            
            //3、拿不到 - 去网上下载，缓存数据
            getDataForInternet(since_id: since_id, max_id: max_id, finished: { (internetDatas, error) in
                
                //缓存网络数据
                finished(internetDatas, error)
            })
            
            
        }
        
    }
    
    
    class func getDataForInternet(since_id : Int , max_id : Int , finished : @escaping (_ models : [[String: AnyObject]]? , _ error : NSError?) -> Void){
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
            
            //缓存微博数据
            PQStatuesDao.cacheStatu(list)
            
            finished(list as [[String : AnyObject]]?, nil)
            
        }, failure: { (_, error) in
            print("网络出错啦！！！！呜啦啦啦")
        })
    }
    
    class func loadCacheStatuses(since_id : Int , max_id : Int , finished : @escaping ([[String: AnyObject]]) -> Void){
        
        //1定义SQL语句
        var sql = "SELECT * FROM " + PQSQLTableName.statusTN.rawValue
        if since_id > 0 {
            sql += "WHERE statuID>\(since_id) \n"
        }else if max_id > 0{
            sql += "WHERE statuID<=\(since_id) \n"
        }
        //排序 检索
        sql += " ORDER BY statuID DESC \n"
        sql += "LIMIT 20;\n"
        var statuses = [[String: AnyObject]]()
        
        do{
            let res = try PQSQLManager.shareManager().db?.executeQuery(sql: sql)
            
            while (res?.next())!
            {
                // 1.取出数据库存储的一条微博字符串
                let dictStr = (res?.string(forColumn: "statu"))! as String
                // 2.将微博字符串转换为微博字典
                let data = dictStr.data(using: .utf8)!
                let dict = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: AnyObject]
                statuses.append(dict)
            }
        }catch{
            print(error)
        }
        
        finished(statuses)
        
    }
    
    class func cacheStatu(_ list : [[String : Any]]){
        
        //1、获取USERID
        let userID = PQOauthInfo.loadAccoutInfo()!.uid! as AnyObject
        
        //2、定义SQL语句
        let sql = "INSERT INTO " + PQSQLTableName.statusTN.rawValue +
            "(statuID,statu,userID) " +
        "VALUES(?,?,?)"
        
        //3、开启事务
        PQSQLManager.shareManager().openTransaction()
        
        //4、插入数据
        for dict in list{
            let statusID = dict["id"]! as AnyObject
            //把JSON转化为strring JSON → 二进制 → 字符串
            let data = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let statusText = String(data: data, encoding: .utf8) as AnyObject
            
            //如果插入失败，就回滚
            do{
                try PQSQLManager.shareManager().db?.executeUpdate(sql: sql, statusID,statusText,userID)
            }catch{
                print(error)
                PQSQLManager.shareManager().rollbackTransaction()
            }
        }
        
        //5、提交事务
        PQSQLManager.shareManager().commitTransaction()
    }
    
}
