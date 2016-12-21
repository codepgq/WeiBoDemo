//
//  PQSQLManager.swift
//  PQWeiboDemo
//
//  Created by 盘国权 on 2016/12/16.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

enum PQSQLTableName : String {
    case statusFN = "T_Status.sqlite"
    case statusTN = "T_Status"
}

class PQSQLManager: NSObject {

    var db : FMDatabase?
    
    func querySQL(_ sql : String) -> [[String : Any]]{
        var allDatas = [[String : Any]]()
        do {
            let result : FMResultSet? = try db?.executeQuery(sql: sql)
            while result!.next() {
                //创建一个字典
                let dict = rowDataFor(result!)
                //得到字典
                allDatas.append(dict)
            }
        } catch {
            print(error)
        }
        return allDatas
    }
    
    
    /// 通过result计算每行的数据，返回一个字典
    fileprivate func rowDataFor(_ result : FMResultSet) -> [String : Any]{
        //创建字典
        var dict = [String : Any]()
        //得到列数
        let count = result.columnCount()
        //计算
        for index in 0..<count {
            let name = result.columnName(for: index)!
            let value = result.object(forColumnName: name)
            print("name - \(name)")
            print("value - \(value)")
            
            dict[name] = value
        }
        
        return dict
    }
    

    
    
    
    /// 更新／插入／删除
    ///
    /// - Parameter sql: sql语句
    /// - Returns: 是否执行成功
    @discardableResult func execSQL(_ sql : String) -> Bool{
       return execWithSQL(sql, transaction: false)
    }
    
    @discardableResult func execSQL(_ sql:String, _ values: AnyObject...) -> Bool{
        do {
            try db?.executeUpdate(sql: sql, values as AnyObject)
            return true
        } catch {
            print(error)
            return false
        }
        
    }
    
    /// 开启事务，更新/插入/删除
    ///
    /// - Parameter sql: sql语句
    /// - Returns: 是否执行成功
    @discardableResult func execTransactionSQL(_ sql: String) -> Bool{
        return execWithSQL(sql, transaction: true);
    }
    
    
    /// 内部方法，根据变量判断是否要开启事务去执行更新/插入/删除
    fileprivate func execWithSQL(_ sql : String , transaction : Bool) -> Bool{
        var isExec : Bool = false
        //开启事物
        if transaction {
            db?.beginTransaction()
        }
        
        do {
            try db?.executeUpdate(sql: sql)
            isExec = true
        } catch {
            print(error)
        }
        
        if transaction {
            //根据是否执行成功来判断是不是要提交活着回滚
            isExec ? db?.commit() : db?.rollback()
        }
        
        return isExec
    }
    
    
    func openTransaction(){
        db?.beginTransaction()
    }
    
    func commitTransaction(){
        let flag : Bool? = db?.commit()
        if let flag = flag {
            if !flag {
                db?.rollback()
            }
        }
    }
    
    func rollbackTransaction(){
        db?.rollback()
    }
    
    func open(_ dbName : String){
        //拼接地址
        db = FMDatabase(path: dbName.documentDir())
        guard let _ = db?.open() else {
            print("创建数据库文件失败")
            return
        }
        print("sqlite Path - \(dbName.documentDir())")
        createTable(PQSQLTableName.statusTN.rawValue)
    }
    
    func createTable(_ tabName : String){
        let sql = "CREATE TABLE IF NOT EXISTS " + tabName +
        "(statuID TEXT PRIMARY KEY,statu TEXT,userID TEXT)"
        
        if !execSQL(sql){ print("创建表失败"); }
    }
    
    static private let manager = PQSQLManager()
    /// 单例对象
    class func shareManager() -> PQSQLManager{
        return manager
    }
}
