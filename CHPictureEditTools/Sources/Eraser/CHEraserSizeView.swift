//
//  CHEraserSizeView.swift
//  ClickFree
//
//  Created by apple on 2024/6/28.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import UIKit

class CHEraserSizeView: UIView {
    private(set) var imageShow: UIImageView! = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    override var intrinsicContentSize: CGSize {
        return imageShow.image?.size ?? .zero
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    func setupUI() {
        addSubview(imageShow)
        imageShow.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    func setupSize(_ size: CGFloat, color: UIColor)  {
        print("set view size: \(size)")
        if size == .zero {
            return
        }
        // 开始图形上下文
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size , height: size ), false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        // 设置填充颜色
        context.setFillColor(color.cgColor)
        // 绘制圆形
        let rect = CGRect(origin: .zero, size: CGSize(width: size , height: size ))
        context.fillEllipse(in: rect)
        // 获取生成的图像
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 结束图形上下文
        UIGraphicsEndImageContext()
        if image != nil {
            imageShow.image = image
            // 刷新内部大小
            invalidateIntrinsicContentSize()
        }
    }
}
