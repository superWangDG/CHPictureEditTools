//
//  CHPhotoEditHandleMainView.swift
//  ClickFree
//
//  Created by apple on 2024/6/29.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import UIKit

protocol CHPhotoEditHandleMainLogic: AnyObject {
    /// 橡皮擦的大小逻辑变更
    func eraserSizeChangeLogicHandle(_ size: CGFloat)
    /// 重新设置图片
    func setImage(_ image: UIImage)
    /// 正在加载中的视图
    /// - Parameters:
    ///   - complete: 是否完成
    ///   - text: 显示的文本
    func loadingHandleImage(_ complete: Bool, text: String?)
    /// 设置橡皮擦的大小
    /// - Parameter size: 屏幕的像素（会转为画布的比例）
    func setEraserSize(_ size: CGFloat)
    /// 获取橡皮擦绘制的路径
    /// - Returns: 路径列表
    func getEraserHistory() -> [[String: CGFloat]]
    /// 清除绘制的橡皮路径
    func clearEraserHistory()
    /// 重置到指定擦除的记录
    /// - Parameter index: 记录的索引
    func setEraserCutIndex(_ index: Int)
    /// 擦除单次的回调
    func editEraserChange(with block: @escaping PhotoEditEraserChangeBlock)
    /// 清除移动的路径
    func clearChangeMoving()
    /// 移动手指的回调
    func movingChangeBlock(with block: @escaping PhotoEditMovingHandle)
    /// 设置是否允许移动图片
    func setMoveTouch(_ move: Bool)
    /// 设置是否能够使用擦除的功能
    func setEraserEnable(_ enable: Bool)
}


class CHPhotoEditHandleMainView: UIView {
    /// 当前图片显示的尺寸
    private(set) var getShowImageSize: CGSize = .zero
    /// 移动的处理
    private var movingChange: PhotoEditMovingHandle?
    /// 使用橡皮擦功能完成
    private var editEraserChange: PhotoEditEraserChangeBlock?
    // 包含图片的滚动视图，实现缩放的功能
    private(set) lazy var mScrollView: UIScrollView = { createScrollView() }()
    // scrollView 内的容器视图
    private(set) lazy var mContentView: UIView = {
        let view = UIView(frame: .zero)
        view.clipsToBounds = false
        return view
    }()
    /// 显示图片的视图
    private(set) lazy var mShowView: CHPhotoEditHandleContentView = {
        let view = CHPhotoEditHandleContentView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resetImageSize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}


internal extension CHPhotoEditHandleMainView {
    /// 橡皮擦的大小逻辑变更
    func eraserSizeChangeLogicHandle(_ size: CGFloat) {
        mShowView.eraserSizeChangeLogicHandle(size)
    }
    /// 重新设置图片
    func setImage(_ image: UIImage) {
        mShowView.setImage(image)
        withImageUpdateLayout(imgSize: image.size, contentSize: mContentView.bounds.size)
    }
    /// 正在加载中的视图
    /// - Parameters:
    ///   - complete: 是否完成
    ///   - text: 显示的文本
    func loadingHandleImage(_ complete: Bool = false, text: String? = nil) {
//        mShowView.loadingHandleImage(complete, text: text)
    }
    /// 设置橡皮擦的大小
    /// - Parameter size: 屏幕的像素（会转为画布的比例）
    func setEraserSize(_ size: CGFloat) {
        mShowView.setEraserSize(size)
    }
    /// 获取橡皮擦绘制的路径
    /// - Returns: 路径列表
    func getEraserHistory() -> [[String: CGFloat]] {
        mShowView.getEraserHistory()
    }
    /// 清除绘制的橡皮路径
    func clearEraserHistory() {
        mShowView.clearEraserHistory()
    }
    /// 重置到指定擦除的记录
    /// - Parameter index: 记录的索引
    func setEraserCutIndex(_ index: Int) {
        mShowView.setEraserCutIndex(index)
    }
    /// 擦除单次的回调
    func editEraserChange(with block: @escaping PhotoEditEraserChangeBlock) {
        editEraserChange = block
        mShowView.editEraserChange(with: block)
    }
    /// 清除移动的路径
    func clearChangeMoving() {
        mShowView.clearChangeMoving()
    }
    /// 移动手指的回调
    func movingChangeBlock(with block: @escaping PhotoEditMovingHandle) {
        movingChange = block
        mShowView.movingChangeBlock(with: block)
    }
    /// 设置是否允许移动图片
    func setMoveTouch(_ move: Bool = false) {
        mShowView.isMoveTouch = move
    }
    /// 设置是否能够使用擦除的功能
    func setEraserEnable(_ enable: Bool = false) {
        mShowView.setEraserEnable(enable)
    }
}

private extension CHPhotoEditHandleMainView {
    func createScrollView() -> UIScrollView {
        let view = UIScrollView(frame: .zero)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.minimumZoomScale = 1.0
        view.maximumZoomScale = 3.0
        view.backgroundColor = .clear
        view.delegate = self
        return view
    }
    func resetImageSize() {
        if let showImage = mShowView.mImgShowView.image, bounds.size != .zero {
            // 当前的图片存在,并且容器的尺寸不为zero
            withImageUpdateLayout(imgSize: showImage.size, contentSize: bounds.size)
        }
    }
    
    func setupUI() {
        addSubview(mScrollView)
        mScrollView.addSubview(mContentView)
        mContentView.addSubview(mShowView)
        mScrollView.snp.makeConstraints({
            $0.leading.trailing.top.bottom.equalToSuperview()
        })
        mContentView.snp.remakeConstraints({
            $0.leading.top.bottom.trailing.equalToSuperview()
            $0.width.height.equalTo(mScrollView)
        })
        mShowView.snp.updateConstraints({
            $0.center.equalToSuperview()
        })
    }
    
    /// 根据图片改编当前面的布局样式
    /// - Parameters:
    ///   - view: 显示的UIImageView视图
    ///   - imgSize: 图片的大小
    ///   - contentSize: 容器的大小
    func withImageUpdateLayout(imgSize: CGSize, contentSize: CGSize) {
        let size = imageAdapterContainer(imgSize, contentSize)
        // 更新图片
        mShowView.snp.remakeConstraints({
            $0.center.equalToSuperview()
            $0.width.equalTo(size.width)
            $0.height.equalTo(size.height)
        })
        self.getShowImageSize = size
    }
    
    /// 图片适配容器的尺寸
    /// - Parameters:
    ///   - imageSize: 图片的尺寸大小
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


extension CHPhotoEditHandleMainView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mContentView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
         let centerPoint = getVisibleCenterPoint(in: scrollView)
        print("Visible center point: \(centerPoint)")
        mShowView.visibleSize = centerPoint
     }
     func getVisibleCenterPoint(in scrollView: UIScrollView) -> CGPoint {
         // 获取 scrollView 的可视区域中心点
         let visibleCenterPoint = CGPoint(x: scrollView.contentOffset.x + scrollView.bounds.width / 2,
                                          y: scrollView.contentOffset.y + scrollView.bounds.height / 2)
         // 将可视区域中心点转换为 contentView 的坐标系
         let centerInContentView = scrollView.convert(visibleCenterPoint, to: mContentView)
         return centerInContentView
     }
}
