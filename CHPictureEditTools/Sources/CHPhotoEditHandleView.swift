//
//  CHPhotoEditHandleView.swift
//  ClickFree
//  AI 图片预处理视图
//  Created by apple on 2024/6/20.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import UIKit

/// 图片编辑错误返回
enum PhotoEditHandleError: Error {
    case mustiPhoneRun
}

public enum CHPhotoEditViewType {
    // 默认展示无任何工具栏只显示图片的预览
    case `default`
    // 擦除
    case erase
    // 证件照换装
    case dress
    // 显示背景替换与尺寸大小设置
    case contextAndSize
}

typealias SavingEditEndBlock = (_ image: UIImage) -> Void
typealias NetworkHandleErrorBlock = (_ msg: String) -> Void
typealias DressCanvasSizeChooseBlock = () -> Void

public class CHPhotoEditHandleView: UIView {
    
    /// 初始化视图
    /// - Parameters:
    ///   - rootView: 显示的图层
    ///   - image: 传递的图片
    ///   - imageName: 图片的名字
    ///   - canvasSize: 画布的大小(不传递的情况下默认使用图片原本的大小)
    ///   - viewType: 视图浏览的类型
    public init(rootView: UIView,
                image: UIImage,
                imageName: String,
                canvasSize: CGSize = .zero,
                viewType: CHPhotoEditViewType = .default
    ) {
        super.init(frame: .zero)
        self.initialization(rootView: rootView, image: image, imageName: imageName, canvasSize: canvasSize, viewType: viewType)
    }
    
    /// 初始化数据
    func setupData(
        image: UIImage,
        imageName: String,
        canvasSize: CGSize
    ) {
        self.originalImage = image
        self.mImageName = imageName
        self.mCanvasSize = canvasSize
        setImage(image)
    }
    
    
    func updateData(_ canvasSize: CGSize) {
        self.mCanvasSize = canvasSize
        self.model.resetCanvasSize(self.mCanvasSize)
    }
    /// 重置显示的图片
    func resetShowImage(_ image: UIImage) {
        showImage = image
    }
    /// 修改初始的默认图片*一般情况下不建议更改原始图片*
    func resetOriginalImage(_ image: UIImage) {
        originalImage = image
    }
    // 重置图片的名字，只有为空的情况下才能赋值成功
    func resetImageName(_ name: String) {
        if mImageName == nil {
            mImageName = name
        }
    }
    func loadingHandleImage(_ complete: Bool = false, text: String? = nil) {
        mContentMainView.loadingHandleImage(complete, text: text)
        mEditEraserToolsView.mBtnSubmit.isEnabled = false
    }
    
    func savingBlock(with block: @escaping SavingEditEndBlock) {
        savingBlock = block
    }
    func networkErrorBlock(with block: @escaping NetworkHandleErrorBlock) {
        errorBlock = block
    }
    func canvasSizeChooseBlock(with block: @escaping DressCanvasSizeChooseBlock) {
        canvasSizeChooseBlock = block
    }
    
    private(set) var viewType: CHPhotoEditViewType!
    // 原始的图片对象
    private(set) var originalImage: UIImage?
    // 工具栏切换容器
    private var stackView = UIStackView(frame: .zero)
    // 编辑工具栏视图
    private(set) var mEditToolsView = CHPhotoEditToolsView()
    // 编辑工具栏的子视图
    private(set) var mEditLinkToolsView = CHPhotoEditToolsLinkedView(frame: .zero)
    // 橡皮擦工具视图
    private(set) var mEditEraserToolsView = CHPhotoEditEraserToolsView(frame: .zero)
    // 工具栏主视图
    private let toolsMainView = UIView()
    // 画布大小
    private(set) var mCanvasSize: CGSize = .zero
    // 图片的名称
    private(set) var mImageName: String? = nil
    private(set) var showImage: UIImage?
    /// 预览的主视图
    let mContentMainView = CHPhotoEditHandleMainView()
    /// 导航栏视图
    let navigateView = CHNavigateView()
    private var savingBlock: SavingEditEndBlock?
    private var errorBlock: NetworkHandleErrorBlock?
    private var canvasSizeChooseBlock: DressCanvasSizeChooseBlock?
    // 图片处理数据层
    private(set) var model: CHPhotoEditHandleModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}
private extension CHPhotoEditHandleView {
    func initialization(rootView: UIView,
                        image: UIImage,
                        imageName: String,
                        canvasSize: CGSize = .zero,
                        viewType: CHPhotoEditViewType = .default) {
        self.viewType = viewType
        setupData(
            image: image,
            imageName: imageName,
            canvasSize: canvasSize == .zero ? image.size : canvasSize
        )
        rootView.addSubview(self)
        self.snp.makeConstraints({ $0.edges.equalToSuperview() })
        setupUI()
    }
    
    func setupUI() {
        model = CHPhotoEditHandleModel(view: self)
        setupStyle()
        setupAppendViews()
        setupLayoutView()
    }
    func setImage(_ image: UIImage) {
        mContentMainView.setImage(image)
    }
    func setupStyle() {
        backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.originalImage = self.showImage
        stackView.axis = .vertical
        stackView.spacing = 15
        toolsMainView.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1)
        toolsMainView.layer.cornerRadius = 12
        toolsMainView.layer.masksToBounds = true
        
        switch viewType {
        case .erase:
            mEditToolsView.isHidden = true
            mEditLinkToolsView.isHidden = true
            mEditEraserToolsView.isHidden = false
        case .dress, .contextAndSize:
            mEditLinkToolsView.isHidden = false
            mEditEraserToolsView.isHidden = true
        default:
            stackView.isHidden = true
        }
    }
    func setupAppendViews() {
        self.addSubview(mContentMainView)
        self.addSubview(toolsMainView)
        self.addSubview(navigateView)
        toolsMainView.addSubview(stackView)
        if viewType != .default {
            stackView.addArrangedSubview(mEditToolsView)
            stackView.insertArrangedSubview(mEditLinkToolsView, at: 0)
            stackView.insertArrangedSubview(mEditEraserToolsView, at: 0)
        }
    }
    func setupLayoutView() {
        mContentMainView.snp.makeConstraints({
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(12)
            if viewType != .default {
                $0.bottom.equalTo(toolsMainView.snp.top).offset(-12)
            } else {
                $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-12)
            }
            $0.trailing.leading.equalToSuperview()
        })
        
        navigateView.snp.makeConstraints({
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        })
        
        if viewType != .default {
            stackView.snp.makeConstraints({
                $0.trailing.leading.equalToSuperview()
                $0.top.equalToSuperview().offset(15)
                $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            })
            mEditToolsView.snp.makeConstraints({
                $0.height.equalTo(80)
            })
            mEditEraserToolsView.snp.makeConstraints({
                $0.height.equalTo(200)
            })
            toolsMainView.snp.updateConstraints({
                $0.trailing.leading.equalToSuperview()
                $0.bottom.equalToSuperview().offset(12)
            })
        }
    }
}
