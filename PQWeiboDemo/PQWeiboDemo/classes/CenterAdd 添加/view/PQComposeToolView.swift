//
//  PQComposeToolView.swift
//  PQWeiboDemo
//
//  Created by Mac on 16/11/7.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

@objc protocol PQComposeToolViewDelegate {
    //选择图片
    func toolDidSelectedShiosePic()
    //@
     func toolDidSelectedAtSomeOne()
    //关于话题
     func toolDidSelectedAboutTalk()
    //表情键盘
     func toolDidSelectedChangeToEmoticon()
    //加号
     func toolDidSelectedAddOhter()
}

class PQComposeToolView: UIToolbar {
    
    weak var toolDelegate : PQComposeToolViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI(){
        var items = [UIBarButtonItem]()
        let imageNames = ["compose_toolbar_picture","compose_mentionbutton_background","compose_trendbutton_background","compose_emoticonbutton_background","compose_addbutton_background"]
        for i in 0..<5{
            let bar = UIBarButtonItem(image: imageNames[i], selected: "\(imageNames[i])_highlighted", target: self, seletor: #selector(PQComposeToolView.toolBarClick(tool:)),tag : i)
            items.append(bar)
            
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        self.items = items

    }
    
    @objc private func toolBarClick(tool : UIBarButtonItem){
        switch tool.tag {
        case 0:toolDelegate?.toolDidSelectedShiosePic()
        case 1:toolDelegate?.toolDidSelectedAtSomeOne()
            
        case 2:toolDelegate?.toolDidSelectedAboutTalk()
        case 3:toolDelegate?.toolDidSelectedChangeToEmoticon()
        default:
            toolDelegate?.toolDidSelectedAddOhter()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
