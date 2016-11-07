//
//  PQComposeTextViewController.swift
//  PQWeiboDemo
//
//  Created by Mac on 16/10/18.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit
import  SVProgressHUD
class PQComposeTextViewController: UIViewController {

    //toolBar 高度约束
    var toolBarHeightCons : NSLayoutConstraint?
    
    //表情键盘
    lazy var emoticon :  EmojiController = EmojiController { (emoticon : Emoticon) -> () in
        self.textView.insertEmoticon(emoticon : emoticon)
    }
    //表情键盘显示标志位
    var isShowEmoticon : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        setupUI()
        
        //监听键盘弹出frame发生改变通知
        NotificationCenter.default.addObserver(self, selector: #selector(PQComposeTextViewController.keyboardSizeValueChanged(noti:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
    
    //键盘通知
    @objc private func keyboardSizeValueChanged(noti : Notification){
//        print(noti.userInfo!)
        let keyPoint : CGPoint = (noti.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect).origin
        toolBarHeightCons?.constant = -(UIScreen.main.bounds.height - keyPoint.y)
//        print("-------------\(toolBarHeightCons)")
        view.layoutIfNeeded()
        
        // 3.更新界面
        let duration = noti.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        
        /*
         工具条回弹是因为执行了两次动画, 而系统自带的键盘的动画节奏(曲线) 7
         7在apple API中并没有提供给我们, 但是我们可以使用
         7这种节奏有一个特点: 如果连续执行两次动画, 不管上一次有没有执行完毕, 都会立刻执行下一次
         也就是说上一次可能会被忽略
         
         如果将动画节奏设置为7, 那么动画的时长无论如何都会自动修改为0.5
         
         UIView动画的本质是核心动画, 所以可以给核心动画设置动画节奏
         */
        // 1.取出键盘的动画节奏
        let curve = noti.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        
        UIView.animate(withDuration: duration.doubleValue) { () -> Void in
            // 2.设置动画节奏
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve.intValue)!)
            
            self.view.layoutIfNeeded()
        }
        
//        let anim = toolbar.layer.animation(forKey: "position")
//        print("duration = \(anim?.duration)")
    }
    
    
    private func setupUI(){
        view.addSubview(textView)
        view.addSubview(toolbar)
        toolbar.toolDelegate = self
        
        textView.pq_fill(referView: view)
        placeholderLabel.pq_AlignInner(type: .TopLeft, referView: textView, size: nil ,offset: CGPoint(x: 5, y: 8))
        let cons =  toolbar.pq_AlignInner(type: pq_AlignType.BottomLeft, referView: view, size: CGSize(width: UIScreen.main.bounds.width, height: 49))
        
       //获取到高度约束
        toolBarHeightCons = toolbar.pq_ConstraintBottom(constraintsList: cons)
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    
    
    private func setNav(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(closeVC))
        navigationItem.rightBarButtonItem  = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(sendStatus))
        navigationItem.titleView = composeTitleView
    }
    
    //取消
    @objc private func closeVC(){
        gotoHomeVC()
    }
    
    private func gotoHomeVC(){
       dismiss(animated: true, completion: nil)
    }
    
    //发送
    @objc private func sendStatus(){
        let url = "2/statuses/update.json"
        let text = textView.getRequestStr()
        let params = ["access_token":PQOauthInfo.loadAccoutInfo()?.access_token,"status":text]
        PQNetWorkManager.shareNetWorkManager().post(url, parameters: params, progress: nil, success: { (_, JSON) in
            SVProgressHUD.showSuccess(withStatus: "发送成功")
            self.gotoHomeVC()
            }) { (_, error) in
                print("微博发送失败\n\(error)")
                SVProgressHUD.showError(withStatus: "发送失败")
        }
    }
    
    //method

    // mark - 懒加载
    //标题
    private lazy var composeTitleView : PQComposeTitleView =  PQComposeTitleView()
    //工具条
    private lazy var toolbar : PQComposeToolView = PQComposeToolView(frame: CGRect.zero)
    //textView
    lazy var textView : UITextView = {
         let text = UITextView(frame: CGRect.zero)
        text.delegate = self
        text.alwaysBounceVertical = true
        text.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        text.addSubview(self.placeholderLabel)
        return text
    }()
    //placeholder
    lazy var placeholderLabel : UILabel = {
        let label = UILabel.createLabelWithFontSize(fontSize: 13, textColor: UIColor.lightGray)
        label.text = "分享新鲜事…"
        return label
    }()
}

extension PQComposeTextViewController : UITextViewDelegate,PQComposeToolViewDelegate{
    func textViewDidChange(_ textView: UITextView){
        placeholderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    //选择图片
    func toolDidSelectedShiosePic(){
        
    }
    //@
    func toolDidSelectedAtSomeOne(){
        
    }
    //关于话题
    func toolDidSelectedAboutTalk(){
        
    }
    //表情键盘
    func toolDidSelectedChangeToEmoticon(){
        // 0 取反标志位
        isShowEmoticon = !isShowEmoticon
        
        // 1、关闭键盘
        textView.resignFirstResponder()
        
        // 2、设置键盘的inputView
        textView.inputView = isShowEmoticon ? emoticon.view : nil
        
        // 3、显示键盘
        textView.becomeFirstResponder()
    }
    //加号
    func toolDidSelectedAddOhter(){
        
    }
}
