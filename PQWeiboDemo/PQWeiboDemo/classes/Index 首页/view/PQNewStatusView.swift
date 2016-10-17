//
//  PQNewStatusView.swift
//  PQWeiboDemo
//
//  Created by Mac on 16/10/14.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQNewStatusView: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    func showStatusLabel(){
        UIView.animate(withDuration: 2, animations: { 
            self.transform = self.transform.translatedBy(x: 0, y: 44 * 3)
            self.alpha = 1
            }) { (_) in
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    DispatchQueue.main.async(execute: { 
                        self.closeStatusLabel()
                    })
                })
        }
    }
    
    func closeStatusLabel(){
        UIView.animate(withDuration: 1.25) {
            self.transform = self.transform.translatedBy(x: 0, y: 44 * -3)
            self.alpha = 0
        }
    }
    
    func updateWithCount (_ count :  Int?){
        let str = "当前微博列表已经是最新"
        text = ((count == nil ) ? str : ( count! > 0 ? "更新了\(count!)条微博" : str ))
    }
    
    private func setupUI(){
        self.transform = self.transform.translatedBy(x: 0, y: 44 * -2)
        self.alpha = 0
        backgroundColor = UIColor.orange
        textColor = UIColor.white
        font = UIFont.systemFont(ofSize: 15)
        textAlignment  = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
