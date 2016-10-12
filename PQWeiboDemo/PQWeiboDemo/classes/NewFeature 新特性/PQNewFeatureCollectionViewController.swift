//
//  PQNewFeatureCollectionViewController.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/29.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PQNewFeatureCollectionViewController: UICollectionViewController {

    /// 一共有几页
    private let itemCount = 4;
    
    private var layout : UICollectionViewFlowLayout = NewFeatureLayout()
    
    //设置布局，这里需要注意的是collectionView默认的初始化函数是带参数的这个，而不是不带参数的
    init(){
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(CollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionCell
        
        cell.imageIndex = indexPath.item
        
        return cell
    }
    
    //完全显示一个Cell是调用
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //这里需要注意的是，indexPath拿到的是上一个cell的索引
        //        print(indexPath)
        
        //在一般情况下，我们可能会看到很多个CollectionViewCell，但是这里我们把Cell大小设置成为了全屏大小，所以这里我们可以使用这个方法去获取已经在屏幕上显示的Cell的indexPath
        let index = collectionView.indexPathsForVisibleItems.last
        if index?.item == itemCount - 1 {
            let cel = collectionView.cellForItem(at: index!) as! CollectionCell
            cel.startButtonAnimation()
        }

    }
    
    
   
}

/// Cell
private class CollectionCell: UICollectionViewCell {
    
    
    var imageIndex : Int?{
        didSet{
            imageView.image = UIImage(named: "new_feature_\(imageIndex! + 1)")
            joinIndexBtn.isHidden = true
        }
    }
    
    func startButtonAnimation() {
        joinIndexBtn.isHidden = true
        joinIndexBtn.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        joinIndexBtn.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.75, delay: 0.15, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.init(rawValue: 0), animations: {
            self.joinIndexBtn.transform = CGAffineTransform.identity
            self.joinIndexBtn.isHidden = false
            }) { (_) in
                self.joinIndexBtn.isUserInteractionEnabled = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        ///初始化UI
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI(){
        contentView.addSubview(imageView)
        contentView.addSubview(joinIndexBtn)
        
        imageView.pq_fill(referView: contentView)
        joinIndexBtn.pq_AlignInner(type: pq_AlignType.BottomCenter, referView: contentView, size: nil, offset: CGPoint(x: 0, y: -160))
    }
    
    private lazy var imageView : UIImageView = UIImageView()
    private lazy var joinIndexBtn :UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "new_feature_button"), for: .normal)
        button.setImage(UIImage(named: "new_feature_button_highlighted"), for: .highlighted)
        
        button.addTarget(self, action: #selector(CollectionCell.joinIndexPage), for: .touchUpInside)
        
        button.sizeToFit()
        
        button.isHidden = true
        
        return button
    }()
    
    @objc private func joinIndexPage() -> Void {
        // 去主页
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PQChangeRootViewControllerKey), object: true)
    }
}


private class NewFeatureLayout : UICollectionViewFlowLayout{
    private override func prepare() {
        //设置layout 大小、Item之间的间距、排列方向
        itemSize = UIScreen.main.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        //设置collectionView的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.isPagingEnabled = true
    }
}
