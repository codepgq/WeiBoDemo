//
//  PQActionSheetVC.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/8.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQActionSheetVC: UIViewController,UITableViewDelegate {

    private let cellIdentifier = "actionSheetCellKey"
    private let datas :NSArray = ["收藏","榜上头条","取消关注","屏蔽","取消"]
    private let rowHeight :CGFloat = 50
    private lazy var tableView : UITableView = {
        let height = CGFloat(self.datas.count) * self.rowHeight
        let frame = CGRect(x: 0, y: (UIScreen.mainScreen().bounds.height - height), width: UIScreen.mainScreen().bounds.width, height:height )
        let tab = UITableView(frame: frame, style: UITableViewStyle.Plain)
        tab.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        tab.rowHeight = self.rowHeight
        return tab
    }()
    
    private var dataSource :TBDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = TBDataSource.cellIdentifierWith(cellIdentifier, data: datas, style: TBSectionStyle.Section_Single, cell: { (cell, item) in
            let newCell = cell as! UITableViewCell
            newCell.textLabel?.text = item as? String
        })
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        view.addSubview(tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
