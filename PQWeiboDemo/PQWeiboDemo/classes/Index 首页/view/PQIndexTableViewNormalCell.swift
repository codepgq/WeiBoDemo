//
//  PQIndexTableViewNormalCell.swift
//  PQWeiboDemo
//
//  Created by Mac on 16/10/13.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQIndexTableViewNormalCell: PQIndexTableViewCell {

    override func setUP(){
        super.setUP()
        
        // 配图
        let cons = pictureView.pq_AlignVertical(type: pq_AlignType.BottomLeft, referView: contentLabel, size: CGSize.zero, offset: CGPoint(x: 0, y: 10))
        
        // 获取配图的宽度
        pictureViewWidthCons = pictureView.pq_ConstraintWidth(constraintsList: cons)
        
        // 获取配图的高度
        pictureViewHeightCons = pictureView.pq_ConstraintHeight(constraintsList: cons)
    }
    

}
