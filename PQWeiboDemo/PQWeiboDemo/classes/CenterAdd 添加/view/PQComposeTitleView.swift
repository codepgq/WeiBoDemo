//
//  PQComposeTitleView.swift
//  PQWeiboDemo
//
//  Created by Mac on 16/11/7.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQComposeTitleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI(){
        let namelabel = UILabel.createLabelWithFontSize(fontSize: 13, textColor: UIColor.darkGray)
        let titleLabel = UILabel.createLabelWithFontSize(fontSize: 15, textColor: UIColor.lightGray)
        titleLabel.text = "发送微博"
        namelabel.text = PQOauthInfo.loadAccoutInfo()?.name
        addSubview(namelabel)
        addSubview(titleLabel)
        
        titleLabel.pq_AlignInner(type: pq_AlignType.Center, referView: self, size: nil, offset: CGPoint(x: 0, y: -10))
        namelabel.pq_AlignVertical(type: pq_AlignType.BottomCenter, referView: titleLabel, size: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
