//
//  PQSQLManager.swift
//  PQWeiboDemo
//
//  Created by 盘国权 on 2016/12/16.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

enum PQSQLTableName : String {
    case status = "T_Status"
}

class PQSQLManager: NSObject {

    var db : FMDatabase?
    func open(_ dbName : String){
        db = FMDatabase(path: dbName.documentDir())
        guard let _ = db else {
            print("创建数据库文件失败")
            return
        }
        createTable()
    }
    
    fileprivate func createTable(){
        let sql = "CREATE TABLE IF NOT EXISTS T_Status" +
                    "(statuID TEXT PRIMARY KEY,statu TEXT,userID TEXT)"
        
        if !execSQL(sql){ print("创建表失败"); }
    }
    
    
    /// 更新／插入／删除
    ///
    /// - Parameter sql: sql语句
    /// - Returns: 是否执行成功
    func execSQL(_ sql : String) -> Bool{
        var isExec : Bool = false
        //开启事物
        db?.beginTransaction()
        do {
            try db?.executeUpdate(sql: sql)
            isExec = true
        } catch {
            print(error)
        }
        //根据是否执行成功来判断是不是要提交活着回滚
        isExec ? db?.commit() : db?.rollback()
        return isExec
    }
    
    static private let manager = PQSQLManager()
    /// 单例对象
    class func shareManager() -> PQSQLManager{
        return manager
    }
}
