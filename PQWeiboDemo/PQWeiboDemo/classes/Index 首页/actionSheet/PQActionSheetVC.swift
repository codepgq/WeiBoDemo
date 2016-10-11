//
//  PQActionSheetVC.swift
//  PQWeiboDemo
//
//  Created by ios on 16/10/8.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQActionSheetVC: UITableViewController {
    
    class func loadForStoryboard() -> PQActionSheetVC{
        return UIStoryboard(name: "ActionSheet", bundle: nil).instantiateInitialViewController() as! PQActionSheetVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentOffset = CGPoint(x: 0, y: UIScreen.main.bounds.height - 316)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dismiss(animated: true, completion: nil)
    }
}
