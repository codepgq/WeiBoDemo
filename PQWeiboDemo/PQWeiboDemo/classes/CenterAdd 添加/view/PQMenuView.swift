//
//  PQMenuView.swift
//  PQWeiboDemo
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit
let cellUsedIdentifierKey = "cellUsedIdentifierKeyMenu"

@objc protocol PQMenuViewDelegate : NSObjectProtocol {
    @objc optional func didSelectedCell(cell : menuCell, indexPath : IndexPath)
}

class PQMenuView: UIView {
    //初始化为三个每行
    lazy var rowCount : Int = 3
    //初始化两行
    lazy var rows : Int = 2
    //能不能滑到第一页
    lazy var isCanScroll = false
    //是不是移除动画
    var isRemove : Bool = false{
        didSet{
            if isRemove {
                collectionView.reloadData()
            }
        }
    }
    
    weak var delegate : PQMenuViewDelegate?
    
    lazy var datas = [
        [menuModel(title: "文字", image: "tabbar_compose_idea"),
         menuModel(title: "头条", image: "tabbar_compose_headlines"),
         menuModel(title: "照片/视频", image: "tabbar_compose_photo"),
         menuModel(title: "直播", image: "tabbar_compose_video"),
         menuModel(title: "签到", image: "tabbar_compose_lbs"),
         menuModel(title: "更多", image: "tabbar_compose_more")],
        
         [menuModel(title: "点评", image: "tabbar_compose_review"),
          menuModel(title: "音乐", image: "tabbar_compose_music"),
          menuModel(title: "好友圈", image: "tabbar_compose_friend"),
          menuModel(title: "商品", image: "tabbar_compose_productrelease"),
          menuModel(title: "红包", image: "tabbar_compose_envelope"),
          menuModel(title: "秒拍", image: "tabbar_compose_shooting")]
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI(){
        
        clipsToBounds = false
        addSubview(collectionView)
        //添加约束
        collectionView.pq_fill(referView: self)
    }
    
    private lazy var collectionView : UICollectionView = {
         let clv = UICollectionView(frame: CGRect.zero, collectionViewLayout: menuFlowLayout())
        clv.clipsToBounds = false
        clv.register(menuCell.self, forCellWithReuseIdentifier: cellUsedIdentifierKey)
        clv.delegate = self
        clv.dataSource = self
        clv.backgroundColor = UIColor.clear
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(PQMenuView.scrollToSectionOne(ges:)))
        gesture.direction = .right
        clv.addGestureRecognizer(gesture)
        return clv
    }()
    
    @objc private func scrollToSectionOne(ges : UISwipeGestureRecognizer){
        if isCanScroll {
            collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: UICollectionViewScrollPosition.left, animated: true)
            isCanScroll = false
        }
    }
    
    lazy var animation : [TimeInterval] = [0.0,0.15,0.05,0.2,0.1,0.25]
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //内部类
    //布局
    class menuFlowLayout: UICollectionViewFlowLayout{
        override func prepare() {
            super.prepare()
            
            let width = UIScreen.main.bounds.width / 3
            itemSize = CGSize(width: width, height: width)
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            
            collectionView?.showsVerticalScrollIndicator = false
            collectionView?.showsHorizontalScrollIndicator = false
            collectionView?.bounces = false
            collectionView?.isScrollEnabled = false
            
            scrollDirection = .horizontal
        }
    }
}

class menuModel : NSObject{
    var title : String?
    var image : String?
    
    init(title : String,image : String){
        super.init()
        self.title = title
        self.image = image
    }
}

//cell
class menuCell: UICollectionViewCell {
    var model : menuModel?{
        didSet{
            itemView.setImage(UIImage(named:model?.image ?? "null"), for: .normal)
            itemView.setTitle(model?.title, for: .normal)
            
            var offsetX = (contentView.width - (itemView.imageView?.frame.width ?? 0)) * 0.5
            
            itemView.imageEdgeInsets = UIEdgeInsets(top: -10, left: offsetX, bottom: 20, right: offsetX)
            offsetX = itemView.imageView?.frame.width ?? 0
            itemView.titleEdgeInsets = UIEdgeInsets(top: itemView.imageView!.frame.maxY, left: -offsetX * 0.85, bottom: 5, right: offsetX * 0.15)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //初始化UI
        setupUI()
    }
    
    private func setupUI(){
        contentView.addSubview(itemView)
    }
    
    //懒加载
    private lazy var itemView : UIButton = {
        let btn = UIButton(frame: self.contentView.bounds)
        //关闭点击事件
        btn.isUserInteractionEnabled = false
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.backgroundColor = UIColor.clear
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PQMenuView:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return datas[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellUsedIdentifierKey, for: indexPath) as! menuCell
        cell.backgroundColor = UIColor.clear
        cell.model = datas[indexPath.section][indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         isCanScroll = false
        if indexPath.item == 5 {
            if indexPath.section == 0{
                isCanScroll = true
                collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 1) as IndexPath, at: UICollectionViewScrollPosition.left, animated: true)
            }
        }
        
        if !isCanScroll{
            let cell = collectionView.cellForItem(at: indexPath) as! menuCell
            
            weak var weakSelf = self
            UIView.animate(withDuration: 0.25, animations: { 
                cell.transform = cell.transform.scaledBy(x: 1.5, y: 1.5)
                cell.alpha = 0
            }, completion: { (_) in
                weakSelf?.delegate?.didSelectedCell!(cell: cell , indexPath: indexPath)
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        var tranfrom = cell.transform.translatedBy(x: 0, y: UIScreen.main.bounds.height)
        if  isRemove {
            tranfrom = cell.transform
        }
        cell.transform = tranfrom
        cell.alpha = isRemove ? 1 : 0
        let delay = isRemove ? animation[5 - indexPath.item]: animation[indexPath.item]
        UIView.animate(withDuration: 0.45, delay:delay , usingSpringWithDamping: 0.85, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveLinear, animations: {
            if self.isRemove {
                cell.transform = cell.transform.translatedBy(x: 0, y: UIScreen.main.bounds.height)
                cell.alpha = 0
            }
            else{
                cell.alpha = 1
                cell.transform = CGAffineTransform.identity
            }
        }, completion: nil)
    }
}
