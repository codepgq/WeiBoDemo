//
//  PQWeatherView.swift
//  PQWeiboDemo
//
//  Created by Mac on 16/11/1.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

/*
 我的API密钥：h3zarscmipoj3dub
 
 API密钥（key）是用来验证API请求合法性的一个唯一字符串，通过API请求中的key参数传入。
 
 我的用户ID：U0F6DFD7B0
 
 用户ID是在注册心知会员时得到的一个10位字符串，如U123456789。用户ID会被使用在签名验证方式中。
 */

let WEATHER_URL = "https://api.thinkpage.cn/v3/weather/now.json?key=h3zarscmipoj3dub&location=shenzhen&language=zh-Hans&unit=c"

class PQWeatherView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI(){
        //初始化UI
        addSubview(dayLabel)
        addSubview(weekLabel)
        addSubview(dateLabel)
        addSubview(weatherLabel)
        
        //布局
        
        dayLabel.pq_AlignInner(type: pq_AlignType.TopLeft, referView: self, size: CGSize(width: 40, height: 40),offset:  CGPoint(x: 10, y: 10))
        weekLabel.pq_AlignHorizontal(type: pq_AlignType.TopRight, referView: dayLabel, size: nil,offset: CGPoint(x: 10, y: 0))
        dateLabel.pq_AlignHorizontal(type: pq_AlignType.BottomRight, referView: dayLabel, size: nil,offset: CGPoint(x: 10, y: 0))
        weatherLabel.pq_AlignVertical(type: pq_AlignType.BottomLeft, referView: dayLabel, size: nil , offset: CGPoint(x: 0, y: 15))
        
        //加载网络数据
        requestWeatherInfo()
        
        //加载日期信息
        loadDateInfo()
    }
    
    private func loadDateInfo(){
        self.dayLabel.text = NSDate.Day()
        self.weekLabel.text = NSDate.weekDay()
        self.dateLabel.text = "\(NSDate.Month())/\(NSDate.Year())"
    }
    
    private func requestWeatherInfo(){
        weak var weakSelf = self
        PQNetWorkManager.shareNetWorkManager().get(WEATHER_URL, parameters: nil, progress: nil, success: { (_, JSON) in
            let dict = JSON as! [String : Any]
            let now = (dict["results"] as! [[String : Any]]).first!["now"] as! [String : Any]
            weakSelf?.weatherLabel.text = "深圳:\(now["text"]!)\(now["temperature"]!)°C"
        }, failure:  { (_, error) in
            weakSelf?.weekLabel.text = "天气更新失败"
        })
    }
    
    // 懒加载
    private lazy var dayLabel : UILabel = {
        let label = UILabel.createLabelWithFontSize(fontSize: 35, textColor: UIColor.darkGray)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private lazy var weekLabel : UILabel = UILabel.createLabelWithFontSize(fontSize: 13, textColor: UIColor.lightGray)
    private lazy var dateLabel : UILabel = UILabel.createLabelWithFontSize(fontSize: 13, textColor: UIColor.lightGray)
    private lazy var weatherLabel : UILabel = UILabel.createLabelWithFontSize(fontSize: 14, textColor: UIColor.lightGray)
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
