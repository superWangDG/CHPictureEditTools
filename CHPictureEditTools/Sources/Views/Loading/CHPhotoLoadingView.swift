//
//  CHPhotoLoadingView.swift
//  ClickFree
//  编辑时的加载视图
//  Created by apple on 2024/6/24.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import UIKit


protocol CHPhotoLoadingViewProtocol: UIView {
    associatedtype ViewModelType: CHPhotoLoadingViewModel
    var viewModel: ViewModelType { get set }
}

class CHPhotoLoadingView: UIView, CHPhotoLoadingViewProtocol {
//    func startAnimation() {
//        mLoadingView.startAnimation()
//        refershLayout()
//    }
//    func stopAnimation() {
//        mLoadingView.stopAnimation()
//    }
    typealias ViewModelType = CHPhotoLoadingViewModel
    var viewModel: ViewModelType {
        didSet {
            
        }
    }
    /// 加载动作的组件
    let mLoadingView: CHPhotosDotView = CHPhotosDotView()
    private lazy var mMainView: UIView = createMainView(color: viewModel.config.mainColor)
    private(set) lazy var titleLab: UILabel = createLabel(
        font: viewModel.config.tipFont,
        textColor: viewModel.config.tipColor
    )
    private(set) lazy var bottomLab: UILabel = createLabel(
        font: viewModel.config.bottomFont,
        textColor: viewModel.config.bottomColor
    )
    init(viewModel: CHPhotoLoadingViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = .init()
        super.init(coder: coder)
        setupUI()
    }
    func updateConfigure() {
        _updateConfigure()
    }
}

private extension CHPhotoLoadingView {
    func _updateConfigure() {
        viewModel.updateConfig()
        refershLayout()
    }
    
    func createMainView(color: UIColor) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = color
        return view
    }
    
    func createLabel(font: UIFont, textColor: UIColor) -> UILabel {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = font
        label.textColor = textColor
        return label
    }
    func setupUI() {
        addSubview(mMainView)
        mMainView.addSubview(mLoadingView)
        mMainView.addSubview(bottomLab)
        mMainView.addSubview(titleLab)
        mMainView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    func refershLayout() {
        // 更新mLoadingView的布局
        mLoadingView.snp.remakeConstraints({
//            $0.centerX.equalToSuperview().offset(-(self.mLoadingView.viewModel.calculateTotalWidth() / 2.0))
//            $0.centerY.equalToSuperview().offset(-(self.mLoadingView.viewModel.config.size / 2.0 + 50))
            $0.centerX.equalToSuperview().offset(-(10 / 2.0))
            $0.centerY.equalToSuperview().offset(-(self.mLoadingView.viewModel.config.size / 2.0 + 50))
        })
        // 更新mLabTitle的布局
        titleLab.snp.remakeConstraints({
            $0.left.equalTo(self.mMainView).offset(15)
            $0.right.equalTo(self.mMainView).offset(-15)
            $0.top.equalTo(self.mLoadingView.snp.bottom).offset(35)
        })
        // 更新mLabBottom的布局
        bottomLab.snp.remakeConstraints({
            $0.left.greaterThanOrEqualToSuperview().offset(15)
            $0.right.greaterThanOrEqualToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-25)
            $0.centerX.equalToSuperview()
        })
    }
}
