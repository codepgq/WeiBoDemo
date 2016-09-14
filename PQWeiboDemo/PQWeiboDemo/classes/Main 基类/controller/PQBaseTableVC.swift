//
//  PQBaseTableVC.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/12.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQBaseTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let visitor = PQNotLoginView(frame: UIScreen.mainScreen().bounds)
        view.addSubview(visitor)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

}
