//
//  PQIndexTableViewCell.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/8.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQIndexTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUP()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUP(){
        contentView.addSubview(backgroundImage)
        contentView.addSubview(iconView)
        contentView.addSubview(iconTypeView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(vipView)
        contentView.addSubview(balloonView)
        contentView.addSubview(diamondView)
        contentView.addSubview(downMenuView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(haveImageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(bottomView)
        
        //背景
        backgroundImage.pq_fill(self)
        
        //头像约束
        iconView.pq_AlignInner(type: pq_AlignType.TopLeft, referView: contentView, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
        //认证头像
        iconTypeView.pq_AlignInner(type: pq_AlignType.BottomRight, referView: iconView, size: CGSize(width: 15, height: 15), offset: CGPoint(x: 0, y: 0))
        //昵称约束
        nameLabel.pq_AlignHorizontal(type: pq_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        //vip
        vipView.pq_AlignHorizontal(type: pq_AlignType.TopRight, referView: nameLabel, size: nil, offset: CGPoint(x: 5, y: 0))
//        //气球
        balloonView.pq_AlignHorizontal(type: pq_AlignType.TopRight, referView: vipView, size: nil, offset: CGPoint(x: 5, y: 0))
        //钻石
        diamondView.pq_AlignHorizontal(type: pq_AlignType.TopRight, referView: balloonView, size: nil, offset: CGPoint(x: 5, y: 0))
//        //下拉菜单
        downMenuView.pq_AlignInner(type: pq_AlignType.TopRight, referView: contentView, size: CGSize(width: 30 ,height: 25), offset: CGPoint(x: -10, y: 10))
        //时间约束
        timeLabel.pq_AlignHorizontal(type: pq_AlignType.BottomRight, referView: iconView, size: nil , offset: CGPoint(x: 10, y: 0))
        //来源约束
        sourceLabel.pq_AlignHorizontal(type: pq_AlignType.TopRight, referView: timeLabel, size: nil, offset: CGPoint(x: 7, y: 0))
        //微博时候有图片约束
        haveImageView.pq_AlignHorizontal(type: pq_AlignType.TopRight, referView: sourceLabel, size: CGSize(width: 15, height:15), offset: CGPoint(x: 7, y: 0))
        
        //正文
        contentLabel.pq_AlignVertical(type: pq_AlignType.BottomLeft, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 10))
        
//        //底部按钮
        bottomView.pq_AlignVertical(type: pq_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44), offset: CGPoint(x: -10, y: 10))
        
        bottomView.pq_AlignInner(type: pq_AlignType.BottomRight, referView: contentView, size: nil, offset: CGPoint(x: -10, y: -10))
        
    }
    
    var oauthInfo : PQStatusesModel?{
        didSet{
            // 用户名
            nameLabel.text = oauthInfo?.user?.name
            // 是不是Vip
            vipView.image = oauthInfo?.user?.mbrankImage
            
            balloonView.hidden = (oauthInfo?.user?.isHiddenDiamond)!
            diamondView.hidden = oauthInfo!.isHiddenBalloon
            
            //时间
            timeLabel.text = oauthInfo?.created_at
            // 来源
            sourceLabel.text = oauthInfo?.source
            //是否有配图
            haveImageView.image = UIImage(named: "compose_toolbar_picture")
            //用户微博信息
            contentLabel.text = oauthInfo?.text
            //用户头像
            iconView.sd_setImageWithURL(oauthInfo?.user?.imageURL)
            //用户认证图片
            iconTypeView.image = oauthInfo?.user?.verified_image
            
            // 更新👍 转发
            bottomView.updateTitle(oauthInfo?.repostsString, comment: oauthInfo?.commentsString, zan: oauthInfo?.attitudesString)
        }
    }
    
    // 背景
    private lazy var backgroundImage :UIImageView = UIImageView(image: UIImage(named: "timeline_card_bottom_background"));
    
    //头像
    private lazy var iconView : UIImageView = {
        let icon = UIImageView(image: UIImage(named: "avatar_default_big2"))
        icon.layer.cornerRadius = 50 * 0.5
        return icon
    }()
    
    // 认证类型
    private lazy var iconTypeView : UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    
    // 昵称
    private lazy var nameLabel : UILabel = UILabel.createLabelWithFontSize(14, textColor: UIColor.darkGrayColor())
    
    // 下拉菜单 actionSheet
    private lazy var downMenuView : UIButton = {
        let button = UIButton();
        button.setImage(UIImage(named : "navigationbar_arrow_down"), forState: .Normal)
        button.addTarget(self, action: #selector(PQIndexTableViewCell.downMenuBtnClick), forControlEvents: .TouchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.backgroundColor = UIColor.whiteColor()
        return button
    }()
    
    @objc private func downMenuBtnClick(){
        print("show action sheet")
        
    }
    
    // vip
    private lazy var vipView : UIImageView = UIImageView()
    
    // 气球
    private lazy var balloonView : UIImageView = UIImageView(image :UIImage(named: "verified_ball"))
    
    // 钻石
    private lazy var diamondView : UILabel = {
        let label = UILabel.createLabelWithFontSize(13, textColor: UIColor.lightGrayColor())
        label.text = "💍"
        return label
    }()
    
    // 时间
    private lazy var timeLabel :UILabel = UILabel.createLabelWithFontSize(12, textColor: UIColor.lightGrayColor())
    
    // 来源
    private lazy var sourceLabel :UILabel = UILabel.createLabelWithFontSize(12, textColor: UIColor.lightGrayColor())
    
    // 图片，是否有图片
    private lazy var haveImageView : UIImageView = UIImageView()
    
    // 正文
    private lazy var contentLabel : UILabel = {
       let label = UILabel.createLabelWithFontSize(14, textColor: UIColor.darkGrayColor())
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 20
        return label
    }()
    
    // 底部按钮
    private var bottomView : PQIndexCellBottomView = PQIndexCellBottomView()
}


