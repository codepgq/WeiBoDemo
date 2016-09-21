//
//  PQNotLoginView.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/14.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

protocol PQNotLoginViewDelegate : NSObjectProtocol {
    func loginButtonDidClick()
    func registerButtonDidClick()
    func concernButtonDidClick()
}

class PQNotLoginView: UIView {
    
    weak var delegate : PQNotLoginViewDelegate?
    
    func setBackgroundImageWithIsIndex(isIndex : Bool,imageNamed : String){
        //根据bool值设置显示内容
        login.hidden = isIndex
        registerBtn.hidden = isIndex
        concern.hidden = !isIndex
        smallicon.hidden = !isIndex
        //设置图片
        house.image = UIImage(named: imageNamed)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        
        //添加转盘
        addSubview(smallicon)
        //遮罩
        addSubview(smalliconMask)
        //房子
        addSubview(house)
        //关注
        addSubview(concern)
        //添加登录
        addSubview(login)
        //添加注册
        addSubview(registerBtn)
        //消息
        addSubview(messageLabel)
        
        //设置约束
        //转盘约束
        smallicon.pq_AlignInner(type: .Center, referView: self, size: nil, offset: CGPoint(x: 0, y: -100))
        //房子约束
        house.pq_AlignInner(type: .Center, referView: self
            , size: nil,offset: CGPoint(x: 0, y: -100))
        //label约束
        messageLabel.pq_AlignVertical(type: pq_AlignType.BottomCenter, referView: smallicon, size:nil)
        
        //“哪个控件” 的 “什么属性” “等于” “哪个控件” 的 “什么属性” 乘以“多少” 加上“多少”
        let widthCons = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224)
        addConstraint(widthCons)
        
        //关注按钮约束
        concern.pq_AlignVertical(type: .BottomCenter, referView: messageLabel, size: CGSizeMake(100, 35))
        
        //登录按钮
        login.pq_AlignVertical(type: pq_AlignType.BottomLeft, referView: messageLabel, size: CGSizeMake(100, 35))
        
        //注册按钮
        registerBtn.pq_AlignVertical(type: pq_AlignType.BottomRight, referView: messageLabel, size: CGSizeMake(100, 35))
        
        //设置蒙版
        smalliconMask.pq_fill(self)
        
        //开始动画
        startAnimation()
        
        
        login.hidden = true
        registerBtn.hidden = true
        concern.hidden = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func startAnimation(){
        let baseAnimation = CABasicAnimation(keyPath: "transform.rotation")
        //360°
        baseAnimation.toValue = M_PI * 2
        baseAnimation.repeatCount = MAXFLOAT
        baseAnimation.duration = 20
        baseAnimation.removedOnCompletion = false
        
        smallicon.layer .addAnimation(baseAnimation, forKey: nil)
    }
    
    func  setUpVisitor(){
        
    }
    
    //转盘
    lazy var smallicon : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        imageView.sizeToFit()
        return imageView
    }()
    //主页
    lazy var house : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        imageView.sizeToFit()
        return imageView
    }()
    //消息
    lazy var message : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_message"))
        imageView.sizeToFit()
        return imageView
    }()
    //logo
    lazy var logo : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_logo"))
        imageView.sizeToFit()
        return imageView
    }()
    //转盘遮罩
    lazy var smalliconMask : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        imageView.sizeToFit()
        return imageView
    }()
    //message Label
    lazy var messageLabel :UILabel = {
        let label = UILabel()
        label.numberOfLines = 0;
        label.textColor = UIColor.darkGrayColor()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .Center
        label.text = "关注一些人，回来看看这里有换什么惊喜"
        return label
    }()
    
    //关注
    lazy var concern : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        
        button.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: .Normal)
        button.addTarget(self, action: #selector(PQNotLoginView.corcernBtnClick), forControlEvents: .TouchUpInside)
        button.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        button.setTitle("去关注", forState: .Normal)
        return button
    }()
    //点击关注
    @objc private func corcernBtnClick(){
        delegate?.concernButtonDidClick()
    }
    
    //登录
    lazy var login : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        button.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: .Normal)
        button.addTarget(self, action: #selector(PQNotLoginView.loginBtnClick), forControlEvents: .TouchUpInside)
        button.setTitle("登录", forState: .Normal)
        button.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        return button
    }()
    
    //点击登录
    @objc private func loginBtnClick(){
        delegate?.loginButtonDidClick()
    }
    
    //注册
    lazy var registerBtn : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        button.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: .Normal)
        button.addTarget(self, action: #selector(PQNotLoginView.registerBtnClick), forControlEvents: .TouchUpInside)
        button.setTitle("注册", forState: .Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        return button
    }()
    //点击注册
    @objc private func registerBtnClick(){
        delegate?.registerButtonDidClick()
    }
}
