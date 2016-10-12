//
//  PQIndexTableViewCell.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/8.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit
import SDWebImage

class PQIndexTableViewCell: UITableViewCell {
    /// 保存配图宽度约束
    private var pictureViewWidthCons : NSLayoutConstraint?
    /// 保存配图高度约束
    private var pictureViewHeightCons : NSLayoutConstraint?
    /// 保存配图顶部约束
    private var pictureViewTopCons : NSLayoutConstraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUP()
    }
    
    private func setUP(){
        contentView.addSubview(backgroundImage)
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView) // 配图
        contentView.addSubview(bottomView)
        
        //背景
        backgroundImage.pq_fill(referView: self)
        
       //顶部视图
        topView.pq_AlignInner(type: pq_AlignType.TopLeft, referView: contentView, size: CGSize(width: UIScreen.main.bounds.width, height: 60))
        topView.menuButtonClick = { (cell : PQIndexCellTopView) -> Void in
            guard  let block = self.showMenu else { return }
            block(self.topView)
        }
        //正文
        contentLabel.pq_AlignVertical(type: pq_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint(x: 10, y: 10))
        
        // 配图
        let cons = pictureView.pq_AlignVertical(type: pq_AlignType.BottomLeft, referView: contentLabel, size: nil, offset: CGPoint(x: 0, y: 10))
        
        // 获取配图的宽度
        pictureViewWidthCons = pictureView.pq_Constraint(constraintsList: cons, attribute: NSLayoutAttribute.width)
        // 获取配图的高度
        pictureViewWidthCons = pictureView.pq_Constraint(constraintsList: cons, attribute: NSLayoutAttribute.height)
        // 获取配图的顶部距离
        pictureViewWidthCons = pictureView.pq_Constraint(constraintsList: cons, attribute: NSLayoutAttribute.top)
        
//        //底部按钮
        bottomView.pq_AlignVertical(type: pq_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: UIScreen.main.bounds.width, height: 44), offset: CGPoint(x: -10, y: 10))
        
//        bottomView.pq_AlignInner(type: pq_AlignType.BottomRight, referView: contentView, size: nil, offset: CGPoint(x: -10, y: -10))
        
    }
    
    // 设置数据
    var statuses : PQStatusesModel?{
        didSet{
            //设置头图视图信息
            topView.statuses = statuses
            
            //用户微博信息 正文
            contentLabel.text = statuses?.text
            
            // 配图
            pictureView.statuses = statuses
            let size = pictureView.carculatePictSize(statu: statuses!)
            pictureViewWidthCons?.constant = size.pictSize.width
            pictureViewHeightCons?.constant = size.pictSize.height
            
            
            // 更新👍 转发 工具栏
            bottomView.updateTitle(forward: statuses?.repostsString, comment: statuses?.commentsString, zan: statuses?.attitudesString)
        }
    }
    
    
    func rowHeight(statuses : PQStatusesModel) -> CGFloat {
        //设置一次
        self.statuses = statuses
        //强制更新
        self.layoutIfNeeded()
        //返回底部的最大x值
        return bottomView.frame.maxY
    }
    
    /// 懒加载 UI
    // 背景
    private lazy var backgroundImage :UIImageView = UIImageView(image: UIImage(named: "timeline_card_bottom_background"));
    
    var showMenu : ((_ cell : PQIndexCellTopView)->())?
    private lazy var topView : PQIndexCellTopView =  PQIndexCellTopView()
    
    // 正文
    private lazy var contentLabel : UILabel = {
       let label = UILabel.createLabelWithFontSize(fontSize: 14, textColor: UIColor.darkGray)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 20
        return label
    }()
    
    /// 配图
    private var pictureView : PQIndexCellPictureView = PQIndexCellPictureView()
    
    // 底部按钮
    private var bottomView : PQIndexCellBottomView = PQIndexCellBottomView()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}






