//
//  EmojiController.swift
//  EmojiKeyBoard
//
//  Created by Mac on 16/10/25.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

 let EmojiReuseIdentifier = "PQCellWithReuseIdentifier"

class EmojiController: UIViewController {
    
    var didSelectedEmoticon : ((_ emoticon : Emoticon) -> ())?
    var isShowTips : Bool = false
    
    var packges : [EmoticonPackge] = EmoticonPackge.packgesList
    
    init(emoticon : @escaping (_ emoticon : Emoticon) -> ()){
        super.init(nibName: nil, bundle: nil)
        didSelectedEmoticon = emoticon
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(packges);
        view.addSubview(collectionView)
        view.addSubview(tollBarView)
        
        collectionView.addSubview(showTipView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        tollBarView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(emoticonCollectionCell.self, forCellWithReuseIdentifier: EmojiReuseIdentifier)
        collectionView.backgroundColor = UIColor.white
        collectionView.layer.borderColor = UIColor.gray.cgColor
        collectionView.layer.borderWidth = 1
        
        var cons = [NSLayoutConstraint]()
        let dict = ["collectionView":collectionView,"tollBarView":tollBarView] as [String : Any]
        
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tollBarView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-[tollBarView(44)]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: dict)

        view.addConstraints(cons)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        showTipView.frame = collectionView.bounds
    }
    
    lazy var showTipView : UILabel = {
         let view = UILabel()
        view.text = "空空如也哦，赶紧去使用表情吧"
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.lightGray
        return view
    }()
    
    private lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionLayout())
    
    private lazy var tollBarView :UIToolbar = {
         let tool = UIToolbar(frame: CGRect.zero)
        var items = [UIBarButtonItem]()
        for i in 0..<self.packges.count{
            let title = self.packges[i].group_name_cn
            let btn = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: #selector(EmojiController.toolBarDidSelected(item:)))
            btn.tag = i
            items.append(btn)
            let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            items.append(space)
        }
        items.removeLast()
        tool.items = items
        return tool;
    }()
    //滚到指定列
    @objc private func toolBarDidSelected(item : UIBarButtonItem){
        collectionView.scrollToItem(at: IndexPath(item: 0, section: item.tag), at: UICollectionViewScrollPosition.left, animated: true)
        
        showTipView.isHidden = (item.tag == 0 && isShowTips ) ? true : false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmojiController:UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packges.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packges[section].emoticons?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiReuseIdentifier, for: indexPath) as! emoticonCollectionCell
        
        cell.emoticon = packges[indexPath.section].emoticons?[indexPath.item]
        
        showTipView.isHidden = (indexPath.section == 0 && isShowTips ) ? true : false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.section != 0 {
            isShowTips = true
            let emoticon = packges[indexPath.section].emoticons![indexPath.item]
            emoticon.times += 1
            packges[0].appendRecentEmoticon(emoticon: emoticon)
        }
        
        didSelectedEmoticon!((packges[indexPath.section].emoticons?[indexPath.item])!)
    }
    
}

private class emoticonCollectionCell : UICollectionViewCell{
    
    var emoticon : Emoticon?{
        didSet{
            // 1、判断是否是图片表情
            if emoticon!.chs != nil {
                icon.setImage(UIImage(contentsOfFile : emoticon!.imagePath!), for: .normal)
            }
            else{
                //防止重用
                icon.setImage(nil, for: .normal);
            }
            
            //设置Emoji
            icon.setTitle(emoticon?.emojiStr, for: .normal)
            
            if emoticon!.isRemoveButton{
                icon.setImage(UIImage(contentsOfFile : emoticon!.RemoveImagePath), for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI(){
        contentView.addSubview(icon)
    }
    
    private lazy var icon : UIButton = {
         let btn = UIButton(frame: self.contentView.bounds)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        btn.backgroundColor = UIColor.white
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class collectionLayout : UICollectionViewFlowLayout{
    override func prepare() {
        super.prepare()
        let width = UIScreen.main.bounds.width / 7.0
        itemSize = CGSize(width: width , height: width)
        minimumLineSpacing = 0;
        minimumInteritemSpacing = 0;
        //水平方向
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        
        let y = (collectionView!.bounds.height - 3 * width) * 0.48
        collectionView?.contentInset = UIEdgeInsetsMake(y, 0, y, 0)
    }
}
