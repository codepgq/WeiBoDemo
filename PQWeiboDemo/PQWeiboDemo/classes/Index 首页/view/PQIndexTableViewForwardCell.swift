//
//  PQIndexTableViewForwardCell.swift
//  PQWeiboDemo
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQIndexTableViewForwardCell: PQIndexTableViewCell {

    override var statuses: PQStatusesModel?{
        didSet{
            let name = statuses?.retweeted_status?.user?.name ?? ""
            let text = statuses?.retweeted_status?.text ?? ""
            forwardLabel.text = "@" + name + " :" + text
        }
    }
    
    override func setUP(){
        super.setUP()
        
        contentView.insertSubview(forwardBack, belowSubview: pictureView)
        contentView.insertSubview(forwardLabel , belowSubview: pictureView)
        
        forwardBack.pq_AlignVertical(type: pq_AlignType.BottomLeft, referView: contentLabel, size: nil ,offset:  CGPoint(x: -10, y: 10))
        forwardBack.pq_AlignVertical(type: pq_AlignType.TopRight, referView: bottomView, size: nil)
        
        // 设置转发内容的约束
        forwardLabel.pq_AlignVertical(type: pq_AlignType.BottomLeft, referView: contentLabel, size: nil , offset: CGPoint(x: 0, y: 10))
        
        // 配图
        let cons = pictureView.pq_AlignVertical(type: pq_AlignType.BottomLeft, referView: forwardLabel, size: CGSize.zero, offset: CGPoint(x: 0, y: 10))
        
        // 获取配图的宽度
        pictureViewWidthCons = pictureView.pq_ConstraintWidth(constraintsList: cons)
        
        // 获取配图的高度
        pictureViewHeightCons = pictureView.pq_ConstraintHeight(constraintsList: cons)
        
        pictureViewTopCons = pictureView.pq_ConstraintTop(constraintsList: cons)
    }
    

    /// 背景
    private lazy var forwardBack : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0, alpha: 0.2)
        return btn
    }()
    
    /// 转发微博的内容
    private lazy var forwardLabel : UILabel = {
        let label = UILabel.createLabelWithFontSize(fontSize: 13, textColor: UIColor.lightGray)
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 20
        label.numberOfLines = 0
        return label
    }()
}
