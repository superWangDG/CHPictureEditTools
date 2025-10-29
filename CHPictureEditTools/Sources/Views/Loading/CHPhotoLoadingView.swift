//
//  CHPhotoLoadingView.swift
//  ClickFree
//  编辑时的加载视图
//  Created by apple on 2024/6/24.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import UIKit
import Combine


protocol CHPhotoLoadingViewProtocol: UIView {
    associatedtype ViewModelType: CHPhotoLoadingViewModel
    var viewModel: ViewModelType { get set }
}

class CHPhotoLoadingView: UIView, CHPhotoLoadingViewProtocol {
    typealias ViewModelType = CHPhotoLoadingViewModel
    var viewModel: ViewModelType {
        willSet {
            cancellabels.forEach({ $0.cancel() })
        }
        didSet {
            bindViewModel()
        }
    }
    /// 加载动作的组件
    let dotAnimationView: CHPhotosDotView = CHPhotosDotView()
    private var cancellabels = Set<AnyCancellable>()
    private lazy var mMainView: UIView = createMainView(color: viewModel.config.mainColor)
    private(set) lazy var titleLab: UILabel = createLabel(
        font: viewModel.config.tipFont,
        textColor: viewModel.config.tipColor
    )
    private(set) lazy var bottomLab: UILabel = createLabel(
        font: viewModel.config.bottomFont,
        textColor: viewModel.config.bottomColor
    )
    init(viewModel: ViewModelType = CHPhotoLoadingViewModel()) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = ViewModelType()
        super.init(coder: coder)
        setupUI()
        bindViewModel()
    }
    deinit {
        cancellabels.forEach({ $0.cancel() })
    }
}

private extension CHPhotoLoadingView {
    func bindViewModel() {
        // 配置变化绑定
        viewModel.$config
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.restartAnimationIfNeeded()
            }
            .store(in: &cancellabels)
        // 动画状态绑定 removeDuplicates 避免重复值触发，dropFirst 不触发初始值
        viewModel.$isLoading
            .dropFirst()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self]isShow in
                self?.showAnimation(isShow)
            }
            .store(in: &cancellabels)
    }
    
    func showAnimation(_ isShow: Bool) {
        self.dotAnimationView.viewModel.animation(isShow)
        refershLayout()
        if isShow {
            self.isHidden = !isShow
        }
        UIView.animate(withDuration: viewModel.animationDuration) {
            self.restartAnimationIfNeeded()
            self.alpha = !isShow ? 0 : 1
        } completion: { _ in
            if !isShow {
                self.isHidden = true
            }
        }
    }
    func restartAnimationIfNeeded() {
        // 自动更新布局
        setNeedsLayout()
        layoutIfNeeded()
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
        mMainView.addSubview(dotAnimationView)
        mMainView.addSubview(bottomLab)
        mMainView.addSubview(titleLab)
        mMainView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        self.isHidden = true
    }
    func refershLayout() {
        // 更新mLoadingView的布局
        dotAnimationView.snp.remakeConstraints({
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        })
        // 更新mLabTitle的布局
        titleLab.snp.remakeConstraints({
            $0.left.equalTo(self.mMainView).offset(15)
            $0.right.equalTo(self.mMainView).offset(-15)
            $0.top.equalTo(self.dotAnimationView.snp.bottom).offset(35)
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
