//
//  CHPhotoColorPreview.swift
//  ClickFree
//
//  Created by apple on 2024/6/22.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import UIKit

class CHPhotoColorPreview: CHBasePhotoEditPrview {

    // 设置图片的背景图片
    func setBackgroundImage(_ backImage: UIImage) -> UIImage? {
        if let forwardImg = editImage {
            let margeImage = forwardImg.withBackground(image: backImage)
            self.showImageView.image = margeImage
            return margeImage
        }
        return nil
    }
}
private extension UIImage {
    func withBackground(image: UIImage, opaque: Bool = true) -> UIImage? {
        // 以当前图片的尺寸创建绘图上下文
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        if UIGraphicsGetCurrentContext() == nil { return nil }
        // 绘制背景图片
        image.draw(in: CGRect(origin: .zero, size: size))
        // 绘制当前图片
        draw(in: CGRect(origin: .zero, size: size))
        // 从绘图上下文中获取新的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
