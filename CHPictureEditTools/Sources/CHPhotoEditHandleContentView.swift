//
//  CHPhotoEditHandleContentView.swift
//  ClickFree
//
//  Created by apple on 2024/6/29.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import UIKit
import SnapKit


typealias PhotoEditLoadingShowHandle = (_ complete: Bool,_ text: String?) -> Void
typealias PhotoEditMovingHandle = (_ isChanging: Bool,_ offPoint: CGPoint) -> Void

class CHPhotoEditHandleContentView: UIView {
    // 是否能够移动前置的图片
    var isMoveTouch = false
    
    var visibleSize: CGPoint = .zero
    /// 加载处理的视图
    func loadingHandleImage(_ complete: Bool = false, text: String? = nil) {
//        mLoadingView.mLabBottom.text = text
        mLoadingView.isHidden = complete
        if !complete {
//            mLoadingView.startAnimation()
        } else {
//            mLoadingView.stopAnimation()
        }
    }
    // 设置图片
    func setImage(_ image: UIImage) {
        mEditEraserPerview.editImage = image
        mImgShowView.image = image
    }
    // 设置橡皮擦的大小
    func setEraserSize(_ size: CGFloat) {
        mEditEraserPerview.eraserSize = size
        // 设置居中位置
//        mEraserSizeView.center = visibleSize
        if visibleSize != .zero {
            let newPoint = CGPoint(x: visibleSize.x , y: visibleSize.y )
            mEraserSizeView.snp.remakeConstraints({
                $0.center.equalTo(newPoint)
            })
        }
        print("setting eraser size:\(size)")
    }
    // 获取橡皮擦的路径
    func getEraserHistory() -> [[String: CGFloat]] {
        let hisList = mEditEraserPerview.historyList.flatMap({ $0 })
        return hisList.map { rect in
            return [
                "x": rect.origin.x,
                "y": rect.origin.y,
                "width": rect.size.width,
                "height": rect.size.height
            ]
        }
    }
    /// 橡皮擦的大小逻辑变更
    func eraserSizeChangeLogicHandle(_ size: CGFloat) {
        // 设置预览图的橡皮擦大小
        setEraserSize(size)
        let color = #colorLiteral(red: 0.03529411765, green: 0.5176470588, blue: 0.9490196078, alpha: 0.6)
        mEraserSizeView.setupSize(size, color: color)
        // 显示橡皮擦,几秒后继续隐藏
        mEraserSizeView.isHidden = false
        mEraserSizeView.alpha = 1
        hideEraserSizeView()
    }
    func clearEraserHistory() {
        mEditEraserPerview.cancelDrawList()
    }
    func setEraserCutIndex(_ index: Int) {
        mEditEraserPerview.cutIndexData(index)
    }
    func editEraserChange(with block: @escaping PhotoEditEraserChangeBlock) {
        editEraserChange = block
        mEditEraserPerview.editEraserChange(with: block)
    }
    func clearChangeMoving() {
        positionOffset = .zero
        movingChange?(false, positionOffset)
    }
    func movingChangeBlock(with block: @escaping PhotoEditMovingHandle) {
        movingChange = block
    }
    func setEraserEnable(_ enable: Bool = false) {
        mEditEraserPerview.isHidden = !enable
        mEditEraserPerview.isEnabel = enable
    }
    
    /// 使用橡皮擦功能完成
    private var editEraserChange: PhotoEditEraserChangeBlock?
    private var movingChange: PhotoEditMovingHandle?
    // 加载的视图
    private(set) lazy var mLoadingView: CHPhotoLoadingView = {
        let view = CHPhotoLoadingView(viewModel: CHPhotoLoadingViewModel())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    // 图片视图
    private(set) lazy var mImgShowView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
        return view
    }()
    // 透明视图的占位视图
    private(set) lazy var mImgPlaceholder: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage.loadImage("transparent_background")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // 编辑橡皮擦的预览视图
    private(set) var mEditEraserPerview: CHPhotoEditEraserView = {
        let view = CHPhotoEditEraserView()
        view.isHidden = true
        view.isEnabel = true
        view.isEraset = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // 橡皮擦的大小
    private(set) lazy var mEraserSizeView: CHEraserSizeView = {
        let view = CHEraserSizeView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// 原本图片偏移的位置记录
    private var positionOffset: CGPoint = .zero
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置图片实际的尺寸大小
        mEditEraserPerview.showSize = self.bounds.size
    }
}

private extension CHPhotoEditHandleContentView {
    func hideEraserSizeView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            UIView.animate(withDuration: 0.35) {
                self.mEraserSizeView.alpha = 0
            }completion: { _ in
                self.mEraserSizeView.isHidden = true
            }
        })
    }
    
    // 滑动内部的视图
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        // 拖动前置视图只能够在 cutout和 remover 的类型中能够操作
        print("UIPanGestureRecognizer moving,\(isMoveTouch),callback :\(movingChange != nil)")
        if isMoveTouch {
            let translation = gestureRecognizer.translation(in: mImgShowView)
            switch gestureRecognizer.state {
            case .began:
                // 能够从最后移动的位置继续移动
                gestureRecognizer.setTranslation(positionOffset, in: mImgShowView)
            case .changed:
                positionOffset = translation
                movingChange?(true, positionOffset)
            case .ended: 
                movingChange?(false, positionOffset)
            default:
                break
            }
        }
    }
    
    func setupUI() {
        addSubview(mImgPlaceholder)
        addSubview(mImgShowView)
        addSubview(mEditEraserPerview)
        addSubview(mLoadingView)
        addSubview(mEraserSizeView)
        mImgPlaceholder.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        mImgShowView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        mEditEraserPerview.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        mLoadingView.snp.remakeConstraints({
            $0.edges.equalToSuperview()
        })
        mEraserSizeView.snp.remakeConstraints({
            $0.center.equalToSuperview()
        })
    }
}
