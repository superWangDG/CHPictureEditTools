//
//  CHBasePhotoEditPrview.swift
//  ClickFree
//
//  Created by apple on 2024/6/20.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import UIKit

class CHBasePhotoEditPrview: UIView {

    /// 当前是否激活状态
    var isEnabel = false {
        didSet {
            self.isHidden = !isEnabel
        }
    }
    /// 编辑的图片
    var editImage: UIImage! {
        didSet {
            showImageView?.image = editImage
            layoutSubviews()
        }
    }
    /// 透明的背景视图展示
    private(set) var mTransparentView = UIImageView(frame: .zero)
    /// 预览视图
    private(set) var showImageView: UIImageView! = UIImageView()
    init() {
        super.init(frame: .zero)
        self.setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    func setupUI() {
        let img = UIImage.loadImage("transparent_background")
        mTransparentView.layer.masksToBounds = true
        mTransparentView.contentMode = .scaleAspectFill
        self.mTransparentView.image = img
        addSubview(mTransparentView)
        self.isHidden = !isEnabel
        addSubview(showImageView)
        showImageView.image = editImage
        layoutIfNeeded()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.showImageView.frame = self.bounds
        self.mTransparentView.frame = self.showImageView.frame
    }
    /// 图片适配容器的尺寸
    /// - Parameters:
    ///   - imageSize: 图片的尺寸大虾
    ///   - containerSize: 容器的尺寸大小
    /// - Returns: 计算后的图片大小
    func imageAdapterContainer(_ imageSize: CGSize, _ containerSize: CGSize) -> CGSize {
        var size = CGSize(width: imageSize.width, height: imageSize.height)
        if size.width > containerSize.width {
            size.height *= containerSize.width / size.width
            size.width = containerSize.width
        }
        if size.height > containerSize.height {
            size.width *= containerSize.height / size.height
            size.height = containerSize.height
        }
        return size
    }

}
