//
//  EmoticonAttachment.swift
//  EmojiKeyBoard
//
//  Created by Mac on 16/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

class EmoticonAttachment: NSTextAttachment {
    //保存对应表情的文字
    var chs : String?
    
    class func imageText (emoticon : Emoticon,font:UIFont) -> NSAttributedString{
        
        //1、创建附件
        let attachment = EmoticonAttachment()
        
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile:emoticon.imagePath!)
        
        //设置附件的大小
        let s = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: s, height: s)
        
        //根据附件返回属性字符串
        return NSAttributedString(attachment: attachment)
        
    }
    
}
