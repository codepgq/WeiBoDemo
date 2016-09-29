//
//  String-DirCategory.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/26.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

extension String{
    /**
     将当前字符串拼接到cache目录后面
     */
    func cacheDir() -> String{
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!  as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
     将当前字符串拼接到document目录后面
     */
    func documentDir() -> String
    {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!  as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
     将当前字符串拼接到temp目录后面
     */
    func tempDir() -> String
    {
        let path = NSTemporaryDirectory() as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
}
