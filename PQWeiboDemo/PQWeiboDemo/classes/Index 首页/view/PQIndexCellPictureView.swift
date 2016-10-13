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
    
   let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
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
        contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        //设置背景颜色
        backgroundColor = UIColor(white: 0, alpha: 0.2)
    }
    
    //计算大小的
    func carculatePictSize() -> CGSize {
        
        // 1.取出配图个数
        let count = statuses?.storedPicURLS?.count
        // 2.如果没有配图zero
        if count == 0 || count == nil
        {
            return CGSize.zero
        }
        // 3.如果只有一张配图, 返回图片的实际大小
        if count == 1
        {
            // 3.1取出缓存的图片
            let key = statuses?.storedPicURLS!.first?.absoluteString
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: key!)
            
            layout.itemSize = (image?.size)!
            // 3.2返回缓存图片的尺寸
            return image!.size
        }
        // 4.如果有4张配图, 计算田字格的大小
        let width = 90
        let margin = 15
        layout.itemSize = CGSize(width: width, height: width)
        
        if count == 4
        {
            let viewWidth = width * 2 + margin
            return CGSize(width: viewWidth, height: viewWidth)
        }
        
        // 5.如果是其它(多张), 计算九宫格的大小
        // 5.1计算列数
        let colNumber = 3
        // 5.2计算行数
        let rowNumber = (count! - 1) / 3 + 1
        // 宽度 = 列数 * 图片的宽度 + (列数 - 1) * 间隙
        let viewWidth = colNumber * width + (colNumber - 1) * margin
        // 高度 = 行数 * 图片的高度 + (行数 - 1) * 间隙
        let viewHeight = rowNumber * width + (rowNumber - 1) * margin
        return CGSize(width: viewWidth, height: viewHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension PQIndexCellPictureView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDataSourcePrefetching,UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return statuses?.pictureURLS?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pictureReuseIdentifier, for: indexPath) as! PQIndexCellPictureViewCell
        
        cell.imageURL =  statuses!.pictureURLS![indexPath.item] as URL
        
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
