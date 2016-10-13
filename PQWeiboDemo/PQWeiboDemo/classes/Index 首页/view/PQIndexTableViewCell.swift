//
//  PQIndexTableViewCell.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/8.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit
import SDWebImage

public enum PQIndexCellIdentifier : String{
    case normal = "IndexCellNormal"
    case forward = "IndexCellforward"
    
    static func cellID(status : PQStatusesModel) -> String{
        return status.retweeted_status != nil ? forward.rawValue : normal.rawValue
    }
}

class PQIndexTableViewCell: UITableViewCell {
    /// 保存配图宽度约束
    var pictureViewWidthCons : NSLayoutConstraint?
    /// 保存配图高度约束
    var pictureViewHeightCons : NSLayoutConstraint?
    /// 保存配图顶部约束
    var pictureViewTopCons : NSLayoutConstraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUP()
    }
    
    func setUP(){
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
        
//        //底部按钮
        bottomView.pq_AlignVertical(type: pq_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: UIScreen.main.bounds.width, height: 44), offset: CGPoint(x: -10, y: 10))
        
    }
    
    // 设置数据
    var statuses : PQStatusesModel?{
        didSet{
            //设置头图视图信息
            topView.statuses = statuses
            
            //用户微博信息 正文
            contentLabel.text = statuses?.text
            
            // 配图
            pictureView.statuses = statuses?.retweeted_status != nil ? statuses?.retweeted_status : statuses
            let size = pictureView.carculatePictSize()
            pictureViewWidthCons?.constant = size.width
            pictureViewHeightCons?.constant = size.height
            
            pictureViewTopCons?.constant = size.height == 0 ? 0 : 10
            
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
    lazy var contentLabel : UILabel = {
       let label = UILabel.createLabelWithFontSize(fontSize: 14, textColor: UIColor.darkGray)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 20
        return label
    }()
    
    /// 配图
    lazy var pictureView : PQIndexCellPictureView = PQIndexCellPictureView()
    
    // 底部按钮
    lazy var bottomView : PQIndexCellBottomView = PQIndexCellBottomView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
