//
//  NSDate+Category.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/8.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

extension NSDate{
    /**
     快速创建一个日期
     
     - parameter string:    日期str
     - parameter formatter: formatter
     
     - returns: 日期
     */
    class func stringToDateWithString(string : String,formatter : String) -> NSDate{
        let format = NSDateFormatter()
        format.dateFormat = formatter
        // 必须真机设置，夫走可能不能转换成功
        format.locale = NSLocale(localeIdentifier: "en")
        return format.dateFromString(string)!
    }
    
    
    /// 把日期转化
    var descDate : String{
        //得到当前时间
        let calender = NSCalendar.currentCalendar()
        // 1、判断是否是今天
        if calender.isDateInToday(self){
            // 1.1 得到秒数 
            let second = Int(NSDate().timeIntervalSinceDate(self))
            // 1.2 判断是否是一分钟以内
            if second < 60 {
                return "刚刚"
            }
            // 1.3 判断是不是一小时以内
            if second < (60*60) {
                return "\(second / 60)分钟"
            }
            // 1.4 不是一个小时以内就显示x个小时以前
            return "\(second / (60 * 60))小时前"
        }
        
        // 2、判断是不是昨天
        var formatter = "HH:mm"
        if calender.isDateInYesterday(self) {
            formatter = "昨天:" + formatter
        }
        else{
            // 3、判断是不是一年内 默认一年内
            formatter = "MM-dd" + formatter
            
            // 4、一年前的事情了
            let comps = calender.components(NSCalendarUnit.Year, fromDate: self, toDate: NSDate() , options:NSCalendarOptions(rawValue: 0))
            if comps.year >= 1 {
                formatter = "yyyy-" + formatter
            }
        }
        
        // 5、根据formatter创建时间
        let format = NSDateFormatter()
        format.dateFormat = formatter
        format.locale = NSLocale(localeIdentifier: "en")
        return format.stringFromDate(self)
        
    }
}
