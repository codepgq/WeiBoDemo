//
//  PQMyQRCodeViewController.swift
//  PQWeiboDemo
//
//  Created by ios on 16/9/21.
//  Copyright © 2016年 ios. All rights reserved.
//

import UIKit

class PQMyQRCodeViewController: UIViewController {
    @IBOutlet weak var myQRCode: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "我的名片"
        
        myQRCode.image = createQRCode()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //*********************   私有方法  ***************
    
    private func createQRCode() -> UIImage{
        // 1、创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        // 2、还原滤镜的默认属性
        filter?.setDefaults()
        // 3、设置需要生成二维码的数据
        filter?.setValue("纸巾艺术".dataUsingEncoding(NSUTF8StringEncoding), forKey: "inputMessage")
        // 4、从滤镜中取出生成好的图片 到这里就能获取到生成好的二维码了，但是非常模糊，需要生成高清的
        let bgImage = createNonInterpolatedUIImageFormCIImage((filter?.outputImage)!, size: 500)
        
        // 5、创建头像
        let icon = UIImage(named: "iconhead")
        // 6、合并图片 
        return mergeImageWith(bgImage, foreImage: icon!)
        //PS：在二维码中如果遮挡一部分的二维码是不会造成识别不了的情况的，但是一定要注意
        //不能把三个小正方形给遮挡住，因为那是二维码的入口，通过三个小正方形才能开始
        //获取二维码的数据
    }
    
    private func mergeImageWith(bgImage:UIImage,foreImage:UIImage) -> UIImage{
        //1、开启上下文
        UIGraphicsBeginImageContext(bgImage.size)
        //2、绘制背景图
        bgImage.drawInRect(CGRect(origin: CGPointZero, size: bgImage.size))
        //3、绘制前景图
        let width : CGFloat = 50.0
        let height: CGFloat = 50.0
        let x = (bgImage.size.width - 50.0) / 2.0
        let y = (bgImage.size.height - 50.0) / 2.0
        foreImage.drawInRect(CGRect(x: x, y: y, width: width, height: height))
        //4、取得生成好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //5、关闭上下文
        UIGraphicsEndImageContext()
        //6、返回合成图
        return newImage
    }
    
    /**
     根据CIImage生成指定大小的高清UIImage
     
     :param: image 指定CIImage
     :param: size    指定大小
     :returns: 生成好的图片
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = CGRectIntegral(image.extent)
        let scale: CGFloat = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        
        // 1.创建bitmap;
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef,  CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale);
        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }
}
