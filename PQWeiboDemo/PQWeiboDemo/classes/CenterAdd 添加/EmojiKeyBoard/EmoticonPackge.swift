//
//  Packges.swift
//  EmojiKeyBoard
//
//  Created by Mac on 16/10/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit
class EmoticonPackge: NSObject {
    
    private var id : String?
    var group_name_cn : String?
    var emoticons : [Emoticon]?
    
    static let packgesList = loadPackges()
    
    class func loadPackges() -> [EmoticonPackge]{
        var packges = [EmoticonPackge]()
        
        //加载最近组
       packges.append(loadRecentEmoticon())
        
        
        let path = (emoticonPath() as NSString).appendingPathComponent("emoticons.plist")
        
        let packgesDict = NSDictionary(contentsOfFile: path)
        for dict in packgesDict!["packages"] as! [[String : Any]]  {
            //获取地址
            let packge = EmoticonPackge(id: dict["id"] as! String)
            //添加组
            packges.append(packge)
            //获取文件路径
            let subPath = packge.infoPath()
            //加载表情数组
            packge.loadEmoticon(path : subPath)
            packge.loadEmptyEmotion()
        }
        
        return packges
    }
    
    //加载最近的表情
    class func loadRecentEmoticon() -> EmoticonPackge{
        let recent = EmoticonPackge(id : "")
        recent.group_name_cn = "最近"
        recent.emoticons = [Emoticon]()
        recent.loadEmptyEmotion()
        return recent
    }
    
    init(id : String) {
        super.init()
        self.id = id
    }
    
    // 用于添加最近表情
    func appendRecentEmoticon(emoticon : Emoticon){
        
        // 1.判断是否是删除按钮
        if emoticon.isRemoveButton
        {
            return
        }
        // 2.判断当前点击的表情是否已经添加到最近数组中
        let contains = emoticons!.contains(emoticon)

        if !contains
        {
            // 删除删除按钮
            emoticons?.removeLast()
            emoticons?.append(emoticon)
        }
        
        // 3.对数组进行排序
        var result = emoticons?.sorted(by: { (e1, e2) -> Bool in
            return e1.times > e2.times
        })
        
        // 4.删除多余的表情
        if !contains
        {
            result?.removeLast()
            // 添加一个删除按钮
            result?.append(Emoticon(remove: true))
        }
        
        emoticons = result
        
        print(emoticons?.count ?? "表情为 - 0")
    }
    
    //填充表情
    private func loadEmptyEmotion(){
        /*
         每页显示21个表情，如果有多余的就填充
         */
        let count = emoticons!.count % 21
       
        //如果整除不了，就添加
        for _ in count..<20 {
            emoticons?.append(Emoticon(remove: false))
        }
        //最后一个添加删除按钮
        emoticons?.append(Emoticon(remove: true))
        
    }
    
    //加载表情
    private func loadEmoticon(path : String){
        let dict = NSDictionary(contentsOfFile: path )!
        group_name_cn = dict["group_name_cn"] as? String
        emoticons = [Emoticon]()
        var index = 0
        for dict in dict["emoticons"] as! [[String : Any]] {
            if index == 20 {
                emoticons?.append(Emoticon(remove: true))
                index = 0
            }
            emoticons?.append(Emoticon(dict : dict , id : id!))
            index += 1
        }
    }
    
    //返回每个文件夹的plist文件
   private func infoPath() -> String{
        return ((EmoticonPackge.emoticonPath() as NSString).appendingPathComponent(id!) as NSString).appendingPathComponent("info.plist")
    }
    
    class func emoticonPath() -> String{
        return (Bundle.main.bundlePath as NSString).appendingPathComponent("Emoticons.bundle")
    }
    
}
