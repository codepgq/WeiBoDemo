//
//  Emoticon.swift
//  EmojiKeyBoard
//
//  Created by Mac on 16/10/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

class Emoticon: NSObject {
    //表情对应的文件夹
    var id : String?
    //表情对应名称
    var chs : String?
    //表情对应图片
    var png : String?{
        didSet{
            imagePath = ((EmoticonPackge.emoticonPath() as NSString).appendingPathComponent(id!) as NSString).appendingPathComponent(png!)
        }
    }
    //表情对应的十六进制字符串
    var code : String?{
        didSet{
            // 1、从字符串中取出16进制的数
            let scanner = Scanner(string : code!)
            //2、将十六进制转换为字符串
            var result :UInt32 = 0
            scanner.scanHexInt32(&result)
            //3、将十六进制转化为emoji表情
            emojiStr = "\(Character(UnicodeScalar(result)!))"
        }
    }
    
    //图片地址
    var imagePath : String?
    //emoji表情
    var emojiStr : String?
    //用于标志删除按钮
    var isRemoveButton : Bool = false
  
    //删除按钮地址
    var RemoveImagePath : String = {
        let path = ((EmoticonPackge.emoticonPath() as NSString).appendingPathComponent("Preset") as NSString).appendingPathComponent("compose_emotion_delete_highlighted@2x.png")
        return path
    }()
    
    //记录图片点击次数
    var times : Int = 0
    
    
    //创建普通数据
    init(dict : [String : Any] ,id : String) {
        super.init()
        self.id = id;
        setValuesForKeys(dict)
    }
    
    //创建删除数组
    init(remove : Bool) {
        super.init()
        self.isRemoveButton = remove
    }
    
    //忽略不需要的属性
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
