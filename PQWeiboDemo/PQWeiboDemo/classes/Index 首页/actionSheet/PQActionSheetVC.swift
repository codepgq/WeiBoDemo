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
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PQActionSheetVC{
   override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: nil)
    }
}
