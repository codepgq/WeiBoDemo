//
//  PQIndexCellBottomView.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/8.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

protocol IndexCellBottomViewDelegate : NSObjectProtocol{
    func forwardBtn(button : UIButton) -> Void
    func commentBtn(button : UIButton) -> Void
    func zanBtn(button : UIButton) -> Void
}

class PQIndexCellBottomView: UIView {
    
    private var delegate : IndexCellBottomViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTitle(forward : String?,comment : String?, zan : String?){
        forwardBtn.setTitle(forward, forState: .Normal)
        commentBtn.setTitle(comment, forState: .Normal)
        zanBtn.setTitle(zan, forState: .Normal)
    }
    
    private func setUp(){
//        backgroundColor = UIColor(white: 0.1, alpha: 0.1)
        
        addSubview(forwardBtn)
        addSubview(commentBtn)
        addSubview(zanBtn)
        
        self.pq_HorizontalTile([forwardBtn,commentBtn,zanBtn], insets: UIEdgeInsetsMake(0, 0, 0, 0))
    }
    
    private lazy var forwardBtn : UIButton =  UIButton.createBtnWithTitle("转发", imageNamed: "timeline_icon_retweet", selector: #selector(PQIndexCellBottomView.forwardBtnClick(_:)),target : self)
    
    @objc private func forwardBtnClick(button:UIButton){
        print("点击了转发")
        delegate?.forwardBtn(button)
    }
    
    private lazy var commentBtn : UIButton =  UIButton.createBtnWithTitle("评论", imageNamed: "timeline_icon_comment", selector: #selector(PQIndexCellBottomView.commentBtnClick(_:)),target : self)
    
    @objc private func commentBtnClick(button:UIButton){
        print("点击了评论")
        delegate?.commentBtn(button)
        
    }
    
    private lazy var zanBtn : UIButton =  UIButton.createBtnWithTitle("赞", imageNamed: "timeline_icon_unlike", selector: #selector(PQIndexCellBottomView.zanBtnClick(_:)),target : self)
       
    
    @objc private func zanBtnClick(button:UIButton){
        print("点击了赞")
        delegate?.zanBtn(button)
    }
    
}
