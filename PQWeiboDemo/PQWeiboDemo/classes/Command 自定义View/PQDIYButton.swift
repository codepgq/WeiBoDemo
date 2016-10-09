//
//  PQDIYButton.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/9.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

enum PQButtonLayoutType {
    case LeftTextRightImage
    case Normal
    case TopTextBottomImage
    case TopImageBottomText
}

class PQDIYButton: UIButton {

    
    private var layoutType : PQButtonLayoutType = .Normal
    
    /**
     快速创建一个button
     keys:title,image,selected,highlighted,textColor
     
     - parameter dict:     字典
     - parameter target:   谁来处理事件
     - parameter selector: 方法
     
     - returns: button
     */
    class func createButton(dict : [String : AnyObject] , type : PQButtonLayoutType, target : AnyObject , selector : Selector) -> PQDIYButton{
        let button = PQDIYButton()
        
        button.layoutType = type
        
        if dict["title"] != nil{
            button.setTitle(dict["title"] as? String, forState: .Normal)
        }
        
        if dict["image"] != nil{
            button.setImage(UIImage(named: (dict["image"] as? String)!), forState: .Normal)
        }
        
        if dict["selected"] != nil{
            button.setImage(UIImage(named: (dict["selected"] as? String)!), forState: .Selected)
        }
        
        if dict["highlighted"] != nil{
            button.setImage(UIImage(named: (dict["highlighted"] as? String)!), forState: .Highlighted)
        }
        
        button.addTarget(target, action: selector, forControlEvents: .TouchUpInside)
        
        if dict["textColor"] != nil {
            button.setTitleColor(dict["textColor"] as? UIColor, forState: .Normal)
        }
        
        
        button.sizeToFit()
        
        return button
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        
        switch layoutType {
        case .LeftTextRightImage:
            titleLabel?.frame.origin.x = 0
            imageView?.frame.origin.x = titleLabel!.frame.size.width
            break
        case .TopTextBottomImage:
            titleLabel!.frame.origin.x = 0
            imageView?.frame.origin.x = (frame.width - (imageView?.bounds.width)!) / 2.0
            imageView?.frame.origin.y = titleLabel!.frame.size.height
            break
        case .TopImageBottomText:
            imageView?.frame.origin.y = 0
            imageView?.frame.origin.x = (frame.width - (imageView?.bounds.width)!) / 2.0
            titleLabel?.frame.origin.x = 0
            titleLabel?.frame.origin.y = (imageView?.frame.size.height)! + (imageView?.frame.origin.y)!
            break
           
        default : break
            
        }
    }

}
