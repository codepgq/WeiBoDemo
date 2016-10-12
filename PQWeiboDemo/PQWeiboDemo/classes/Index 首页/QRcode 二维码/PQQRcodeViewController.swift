//
//  PQQRcodeViewController.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/21.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit
import AVFoundation

class PQQRcodeViewController: UIViewController ,AVCaptureMetadataOutputObjectsDelegate{

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var animatorView: UIImageView!
    @IBOutlet weak var animator: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawLine.addSublayer(lineShapeLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBarTitle()
        
        setBarStyle(show: true, color: UIColor.black)
        
        //1、设置开始位置
        animator.constant = -containerHeight.constant
        //1.1更新约束
        view.layoutIfNeeded()
        
        //开始扫描
        startScan()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setBarStyle(show: false, color: nil)
    }
    
    
     // ******************************    所有的私有方法    **************************
    
    /**
     开始扫描
     */
    private func startScan(){
        //1、先判断能不能添加输入
        if !session.canAddInput(deviceInput) {
            return
        }
        //2、在判断能不能添加输出
        if !session.canAddOutput(metaDateOutput) {
            return
        }
        //3、把输入输出添加到会话层中
        session.addInput(deviceInput)
        session.addOutput(metaDateOutput)
        //4、设置输出能够解析的数据类型
        metaDateOutput.metadataObjectTypes = metaDateOutput.availableMetadataObjectTypes
        //5、设置输出代理，只要解析成功就通知代理
        metaDateOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        //6、添加预览图层
        view.layer.insertSublayer(previewLayer, at: 0)
        
        //6.1 添加一个边框图层
        previewLayer.addSublayer(drawLine)
        
        
        
        //6.3设置扫描区域
        let interRect :CGRect = previewLayer.metadataOutputRectOfInterest(for: CGRect(x: (UIScreen.main.bounds.width - container.frame.width) / 2.0, y: container.frame.origin.y, width: container.frame.width, height: container.frame.height))
        metaDateOutput.rectOfInterest = interRect
        
        //7、开始扫描
        session.startRunning()
        
        
    }
    
    
   
    
    private func startAnimation(){
        //2、开始动画
        UIView.animate(withDuration: 2, animations: {
            self.animator.constant = self.containerHeight.constant
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.view.layoutIfNeeded()
        })
        
    }
    
    private func setNavigationBarTitle(){
        navigationItem.title = "扫一扫"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.lightText]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action:#selector(PQQRcodeViewController.qrCodeLeftCloceClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "相册", style: UIBarButtonItemStyle.plain, target: self, action:#selector(PQQRcodeViewController.qrCodeRightPhotoClick))
    }
    
    private func setBarStyle(show : Bool, color :UIColor?){
        tabBarController?.tabBar.isHidden = show
        navigationController?.navigationBar.barTintColor = color
        tabBarController?.tabBar.isHidden = show
        if show {
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
        }else{
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
        }
        
    }
    
    
    @objc private func qrCodeLeftCloceClick(){
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @objc private func qrCodeRightPhotoClick(){
        print("点击了相册")
    }
    
    
    // ************************     所有的懒加载     **********************
    //会话层
    private lazy var session : AVCaptureSession = AVCaptureSession()
    
    //输入
    private lazy var deviceInput : AVCaptureDeviceInput? = {
        //获取摄像头，才能拿到输入内容
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do{
            let input = try AVCaptureDeviceInput(device: device)
            return input
        }catch{
            print(error)
            return nil
        }
    }()
    
    //输出
    private lazy var metaDateOutput : AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    // 创建预览图层
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer?.frame = UIScreen.main.bounds
        layer?.videoGravity =  AVLayerVideoGravityResizeAspectFill
        return layer!
    }()
    
    // 创建一个边框图层
    private lazy var drawLine : CALayer = {
        let layer = CALayer()
        layer.frame = UIScreen.main.bounds
        return layer
    }()
    
    //创建一个边框
    lazy var lineShapeLayer : CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = UIScreen.main.bounds
        layer.lineWidth = 4
        layer.strokeColor = UIColor.green.cgColor
        layer.fillColor = nil
        
        return layer
    }()
    
}




//代理
extension PQQRcodeViewController{
    
    @objc(captureOutput:didOutputMetadataObjects:fromConnection:) func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        //输出数据
        print((metadataObjects.last as AnyObject))
        
        lineShapeLayer.path = nil
        
        // 2、去设置二维码的位置
        for object in metadataObjects{
            if object is AVMetadataMachineReadableCodeObject {
                let codeObject = previewLayer.transformedMetadataObject(for: object as! AVMetadataObject ) as! AVMetadataMachineReadableCodeObject
                drawConners(codeObject: codeObject)
            }
        }
    }
    

    
    
    private func drawConners(codeObject: AVMetadataMachineReadableCodeObject){
//        print(codeObject.corners)
        
        //1、如果返回的数据为空，就不用画了
        if codeObject.corners.isEmpty {
            return
        }
        
        //2、创建CAShapeLayer，设置宽度、边框颜色、填充颜色
//        懒加载实现

        //3、设置路径
        let path = UIBezierPath()
        var point = CGPoint.zero
        var index : Int = 0
        
        //3.1获取第一个点
        point = CGPoint(dictionaryRepresentation: (codeObject.corners[index] as! CFDictionary))!
        
        path.move(to: point)
        
        while index < codeObject.corners.count - 1 {
            index += 1
            
            point = CGPoint(dictionaryRepresentation: (codeObject.corners[index] as! CFDictionary))!
            path.addLine(to: point)
        }
        
        
        //4、关闭路径（绘画）
        path.close()
        
        //4.2、回执路径
        lineShapeLayer.path = path.cgPath
    }
}
