//
//  PQIndexCellTopView.swift
//  PQWeiboDemo
//
//  Created by Mac on 16/10/12.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQIndexCellTopView: UIView {
    
   
    
    
    var statuses : PQStatusesModel?{
        didSet{
            // 用户名
            nameLabel.text = statuses?.user?.name
            // 是不是Vip
            vipView.image = statuses?.user?.mbrankImage
            //用户头像
            iconView.sd_setImage(with: statuses?.user?.imageURL as URL!)
            //用户认证图片
            iconTypeView.image = statuses?.user?.verified_image
            // 显示气球
            balloonView.isHidden =  statuses!.isHiddenBalloon
            //显示钻石
            diamondView.isHidden = (statuses?.user?.isHiddenDiamond)!
            
            //时间
            timeLabel.text = statuses?.created_at
            // 来源
            sourceLabel.text = statuses?.source
            //是否有配图
            haveImageView.image = UIImage(named: "compose_toolbar_picture")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUP()
        
    }
    
    private func setUP(){
        addSubview(iconView)
        addSubview(iconTypeView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(balloonView)
        addSubview(diamondView)
        addSubview(downMenuView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(haveImageView)
        
        
        //头像约束
        iconView.pq_AlignInner(type: pq_AlignType.TopLeft, referView: self, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
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
        downMenuView.pq_AlignInner(type: pq_AlignType.TopRight, referView: self, size: CGSize(width: 30 ,height: 25), offset: CGPoint(x: -10, y: 10))
        //时间约束
        timeLabel.pq_AlignHorizontal(type: pq_AlignType.BottomRight, referView: iconView, size: nil , offset: CGPoint(x: 10, y: 0))
        //来源约束
        sourceLabel.pq_AlignHorizontal(type: pq_AlignType.TopRight, referView: timeLabel, size: nil, offset: CGPoint(x: 7, y: 0))
        //微博时候有图片约束
        haveImageView.pq_AlignHorizontal(type: pq_AlignType.TopRight, referView: sourceLabel, size: CGSize(width: 15, height:15), offset: CGPoint(x: 7, y: 0))
    }
    
    
    //头像
    private lazy var iconView : UIImageView = {
        let icon = UIImageView(image: UIImage(named: "avatar_default_big2"))
        icon.layer.cornerRadius = 50 * 0.5
        icon.layer.masksToBounds = true
        return icon
    }()
    
    // 认证类型
    private lazy var iconTypeView : UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    
    // 昵称
    private lazy var nameLabel : UILabel = UILabel.createLabelWithFontSize(fontSize: 14, textColor: UIColor.darkGray)
    
    //点击菜单的闭包
    var menuButtonClick : ((_ cell : PQIndexCellTopView)->())?
    // 下拉菜单 actionSheet
    private lazy var downMenuView : UIButton = {
        let button = UIButton();
        button.setImage(UIImage(named : "navigationbar_arrow_down"), for: .normal)
        button.addTarget(self, action: #selector(PQIndexCellTopView.downMenuBtnClick), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.backgroundColor = UIColor.white
        
        return button
    }()
    
    @objc private func downMenuBtnClick(){
        print("show action sheet")
        guard let block = menuButtonClick else { return }
        block(self)
    }
    
    // vip
    private lazy var vipView : UIImageView = UIImageView()
    
    // 气球
    private lazy var balloonView : UIImageView = UIImageView(image :UIImage(named: "verified_ball"))
    
    // 钻石
    private lazy var diamondView : UILabel = {
        let label = UILabel.createLabelWithFontSize(fontSize: 13, textColor: UIColor.lightGray)
        label.text = "💍"
        return label
    }()
    
    // 时间
    private lazy var timeLabel :UILabel = UILabel.createLabelWithFontSize(fontSize: 12, textColor: UIColor.lightGray)
    
    // 来源
    private lazy var sourceLabel :UILabel = UILabel.createLabelWithFontSize(fontSize:
        12, textColor: UIColor.lightGray
    )
    
    // 图片，是否有图片
    private lazy var haveImageView : UIImageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
