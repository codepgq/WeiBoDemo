//
//  PQImageBrowserCollectionViewCell.swift
//  PQWeiboDemo
//
//  Created by Mac on 16/10/17.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit
import SDWebImage

protocol PQImageBrowserCollectionViewCellDelegate : NSObjectProtocol{
    func browserDidClose(cell :PQImageBrowserCollectionViewCell)
}

class PQImageBrowserCollectionViewCell: UICollectionViewCell {
    
    weak var imageBrowserDelegate : PQImageBrowserCollectionViewCellDelegate?
    var imageURL : URL {
        didSet{
            
            // 还原设置
            dufaultSetting()
            
            // 下载图片
            iconImage.sd_setImage(with: imageURL) { (image, _, _, _) in
                //设置大小位置
                self.setPosition()
            }
        }
    }
    
    private func dufaultSetting(){
        scrollView.contentSize = CGSize.zero
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
        
        iconImage.transform = CGAffineTransform.identity
        
        // 开始加载动画
        activityView.startAnimating()
    }
    
    private func setPosition(){
        // 1、获取到图片，压缩图片
        let size = displayImageSize(image: iconImage.image!)
        
        //判断长度是否超出屏幕长度
        if size.height < PQUtil.screenHeight(){
            iconImage.frame = CGRect(origin: CGPoint.zero, size: size)
            
            let y = (PQUtil.screenHeight() - size.height) * 0.5
            scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
        }
        else{
            iconImage.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView.contentSize = size
        }
        
        
        // 结束加载动画
        activityView.stopAnimating()
    }
    
    //得到图片展示的大小
    private func displayImageSize(image : UIImage) -> CGSize{
        let scale = image.size.height / image.size.width
        
        let width = PQUtil.scrrenWith()
        let height = width * scale
        return CGSize(width: width, height: height)
    }
    
    override init(frame: CGRect) {
        imageURL = URL(string: "www.baidu.com")!
        super.init(frame: frame)
        
        setupUI()
    }
    
    func getVisitorImage() -> UIImage?{
        return iconImage.image
    }
    
    private func setupUI(){
        // 1、添加子控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(iconImage)
        contentView.addSubview(activityView)
        
        //2、布局子控件
        scrollView.frame = contentView.frame
        activityView.pq_AlignInner(type: pq_AlignType.Center, referView: contentView, size: nil)
        
        //3、添加点击事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(PQImageBrowserCollectionViewCell.closeBrowser))
        iconImage.isUserInteractionEnabled = true
        iconImage.addGestureRecognizer(tap)
        
        // 4、设置scrollZoom
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 0.5
        scrollView.delegate = self
    }
    
    @objc private func closeBrowser(){
        imageBrowserDelegate?.browserDidClose(cell: self)
    }
    
    // 懒加载
    private lazy var scrollView = UIScrollView()
    lazy var iconImage = UIImageView()
    private lazy var activityView = UIActivityIndicatorView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PQImageBrowserCollectionViewCell : UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView?{
        return iconImage
    }
    
    //缩放结束
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat){
        let size = view?.frame.size
        
        let offsetX = size!.width > PQUtil.scrrenWith() ? 0 : (PQUtil.scrrenWith() - size!.width) * 0.5
        let offsetY = size!.height > PQUtil.screenHeight() ? 0 : (PQUtil.screenHeight() - size!.height) * 0.5
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
        
        print("size \(size)")
    }
    
    
}
