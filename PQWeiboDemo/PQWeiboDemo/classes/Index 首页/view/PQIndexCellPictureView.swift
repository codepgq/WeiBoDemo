//
//  PQIndexCellPictureView.swift
//  PQWeiboDemo
//
//  Created by Mac on 16/10/12.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit
import SDWebImage

class PQIndexCellPictureView: UICollectionView {

    var statuses : PQStatusesModel?{
        didSet{
            reloadData()
        }
    }
    
    let pictureReuseIdentifier = "pictureReuseIdentifier"
    
    let layout = UICollectionViewFlowLayout()
    
    init(){
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        //注册cell
        register(PQIndexCellPictureViewCell.self, forCellWithReuseIdentifier: pictureReuseIdentifier)
        
        //设置代理
        delegate = self
        dataSource = self
        if #available(iOS 10.0, *) {
            prefetchDataSource = self
        } else {
            // Fallback on earlier versions
        }
        
        //设置cell间隙
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        //设置背景颜色
        backgroundColor = UIColor.darkGray
    }
    
    //计算大小的
    func carculatePictSize(statu : PQStatusesModel) -> (pictSize : CGSize,itemSize : CGSize) {
        
        // 1、判断是否有配图
        if statu.pictureURLS == nil || statu.pictureURLS?.count == 0 {
            return (CGSize.zero,CGSize.zero)
        }
        
        //设置每个item的size
        layout.itemSize = CGSize(width: 90, height: 90)
        
        // 2、如果有一张配图 返回图片大小比例
        if statu.pictureURLS?.count == 1 {
            let key = statu.pictureURLS?.first?.absoluteString
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: key!)
            let size = CGSize(width: (image?.size.width)!, height: (image?.size.height)!)
            return (size,size)
        }
        
        let width = 90.0
        let spaceing = 10.0
        // 3、如果有四张配图 返回田字风格大小
        if statu.pictureURLS?.count == 4 {
            let size = CGSize(width: (width + spaceing) * 2, height: (width + spaceing) * 2)
            return (size,CGSize(width: 90, height: 90))
        }
        
        // 4、都按九宫格计算
        let colNumber = 3
        let row = statu.pictureURLS!.count / colNumber
        let size = CGSize(width: (width + spaceing) * 3, height: Double(row) * (width + spaceing))
        return (size,CGSize(width: 90, height: 90))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension PQIndexCellPictureView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDataSourcePrefetching,UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 5
        //        return statuses?.pictureURLS?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pictureReuseIdentifier, for: indexPath) as! PQIndexCellPictureViewCell
        
        cell.imageURL =  statuses!.pictureURLS![indexPath.item] as URL
        
        print("image url - \(statuses!.pictureURLS![indexPath.item] )")
        return cell
    }
    
    @available(iOS 10.0, *)
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        dump(indexPaths)
    }
}

class PQIndexCellPictureViewCell: UICollectionViewCell {
    
    var imageURL : URL? {
        didSet{
            imageView.sd_setImage(with: imageURL!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //初始化UI
        setUp()
    }
    
    // 初始化UI
    private func setUp(){
        //添加UI
        addSubview(imageView)
        //设置约束
        imageView.pq_fill(referView: self)
    }
    
    
    
    /// 懒加载
    private lazy var imageView : UIImageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
