//
//  PQImageBroserViewController.swift
//  PQWeiboDemo
//
//  Created by Mac on 16/10/15.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit
import  SDWebImage
import SVProgressHUD

let imageBrowserIdentifier = "imageBrowserIdentifier"
class PQImageBroserViewController: UIViewController {

 
    var largeUrls : Array<URL>?
    var currentIndexPath : IndexPath?
    
    init(currenIndex : IndexPath , ulrs : Array<URL>){
        currentIndexPath = currenIndex
        largeUrls = ulrs
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置UI
        setupUI()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        collectionView.scrollToItem(at: currentIndexPath!, at: UICollectionViewScrollPosition.left, animated: false)
        collectionView.isHidden = false
    }
    
    private func setupUI(){
        view.addSubview(collectionView)
        view.addSubview(saveBtn)
        view.addSubview(closeBtn)
        
        collectionView.frame = view.bounds
        collectionView.backgroundColor = PQUtil.randomColor()
        saveBtn.pq_AlignInner(type: pq_AlignType.BottomLeft, referView: view, size: CGSize(width : 80 , height : 44) , offset: CGPoint(x: 10, y: -10))
        closeBtn.pq_AlignInner(type: pq_AlignType.BottomRight, referView: view, size:  CGSize(width : 80 , height : 44) ,offset: CGPoint(x: -10, y: -10))
        
        // 1、设置代理
        collectionView.dataSource = self
        // 2、注册cell
        collectionView.register(PQImageBrowserCollectionViewCell.self, forCellWithReuseIdentifier: imageBrowserIdentifier)

    }
    
    private lazy var collectionView = UICollectionView(frame: PQUtil.screenBounds(), collectionViewLayout: ImageBrowserCollectionViewFlowLayout())
    
    private lazy var saveBtn : UIButton = {
         let btn = UIButton.createBtnWithTitle(title: "关闭", imageNamed: nil, selector: #selector(PQImageBroserViewController.closeBtnClick), target: self)
        btn.backgroundColor = UIColor.gray
        btn.setTitleColor(UIColor.white ,for: .normal)
        return btn
    }()
    private lazy var closeBtn : UIButton = {
        let btn = UIButton.createBtnWithTitle(title: "保存", imageNamed: nil, selector: #selector(PQImageBroserViewController.saveBtnClick), target: self)
        btn.backgroundColor = UIColor.gray
        btn.setTitleColor(UIColor.white ,for: .normal)
        return btn
    }()
    @objc private func saveBtnClick(){
        print("保存")
        
        // 1、获取到显示的Cell
        let index = collectionView.indexPathsForVisibleItems.last
        let cell = collectionView.cellForItem(at: index!) as! PQImageBrowserCollectionViewCell
        
        // 2、获取到图片 
        guard let image = cell.getVisitorImage() else {
            SVProgressHUD.showError(withStatus: "图片未加载完成")
            return
        }
        
        // 3、保存图片
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PQImageBroserViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(image:UIImage, didFinishSavingWithError error:NSError?, contextInfo:AnyObject){
        if error == nil {
            SVProgressHUD.showSuccess(withStatus: "保存成功")
        }else{
            SVProgressHUD.showError(withStatus: "保存失败")
        }
    }
    
    @objc private func closeBtnClick(){
        print("关闭")
        dismiss(animated: true, completion: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//内部类
class ImageBrowserCollectionViewFlowLayout : UICollectionViewFlowLayout{
    
    override func prepare() {
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        itemSize = PQUtil.screenBounds().size
        
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}

extension PQImageBroserViewController: UICollectionViewDataSource,PQImageBrowserCollectionViewCellDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return largeUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageBrowserIdentifier, for: indexPath) as! PQImageBrowserCollectionViewCell
        
        cell.imageURL = largeUrls![indexPath.item]
        cell.backgroundColor = PQUtil.randomColor()
        cell.imageBrowserDelegate = self
        return cell
    }
    
    func browserDidClose(cell: PQImageBrowserCollectionViewCell) {
        dismiss(animated: true, completion: nil)
    }
}


