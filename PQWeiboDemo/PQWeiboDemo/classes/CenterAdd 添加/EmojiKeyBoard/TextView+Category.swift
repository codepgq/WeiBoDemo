//
//  TextView+Category.swift
//  EmojiKeyBoard
//
//  Created by Mac on 16/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

extension UITextView {
    
    func insertEmoticon(emoticon : Emoticon) {
        //如果点击的是删除图片，就回删一个
        if emoticon.isRemoveButton{
            deleteBackward()
        }
        
        //判断是不是emoji表情
        if emoticon.emojiStr != nil {
            self.replace(self.selectedTextRange!, withText: emoticon.emojiStr!)
        }
        
        //普通的图片表情
        if emoticon.png != nil{
            
            let myFont : UIFont = (font != nil) ? font! : UIFont.systemFont(ofSize: 17)
            font = myFont
            
            //创建附件 用于显示图片
            let imageText = EmoticonAttachment.imageText(emoticon: emoticon, font: myFont)
            
            //得到当前的所有的Att str 属性字符串
            let mutableAtt = NSMutableAttributedString(attributedString: attributedText)
            
            //插入表情到光标所在的位置
            let range = selectedRange
            mutableAtt.replaceCharacters(in :range , with :imageText)
            
            //属性字符串有自己的默认尺寸
            mutableAtt.addAttribute(NSFontAttributeName, value: font!, range: NSRange(location: range.location, length: 1))
            
            //将赋值后的字符串赋值给textView
            attributedText = mutableAtt;
            
            //恢复光标所在的位置
            //两个参数：第一个标示光标所在的位置，第二个标示选中的项
            selectedRange = NSRange(location: range.location + 1, length: 0)
            
            //自己去促发TextViewDidChange方法
            delegate?.textViewDidChange!(self)

        }
        
    }
    
    func getRequestStr() -> String{
        var strM = String()
        
        //后去要发送至服务器的数据
        attributedText.enumerateAttributes(in: NSMakeRange(0, attributedText.length), options: NSAttributedString.EnumerationOptions.init(rawValue: 0)) { (objc, range, _) in
            if objc["NSAttachment"] != nil{
                //图片
                let attachment = objc["NSAttachment"] as! EmoticonAttachment
                strM += attachment.chs!
            }else{
                strM += (self.text as NSString).substring(with: range)
            }
        }
        return strM
    }
    
}
