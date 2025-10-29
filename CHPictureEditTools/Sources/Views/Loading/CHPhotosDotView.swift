//
//  CHPhotosDotView.swift
//  ClickFree
//
//  Created by apple on 2024/4/8.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import UIKit
import Combine

protocol CHPhotoDotViewProtocol: UIView {
    associatedtype ViewModelType: CHPhotoDotViewModelProtocol
    var viewModel: ViewModelType { get set }
    func setupDotViews()
    func updateLayout()
    func restartAnimationIfNeeded()
}

class CHPhotosDotView: UIView, CHPhotoDotViewProtocol {
    typealias ViewModelType = CHPhotosDotViewModel
    var viewModel: ViewModelType {
        didSet {
            bindViewModel()
        }
    }
    weak var delegate: CHPhotoDotDelegate?
    
    private var dotViews: [UIView] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ViewModelType = CHPhotosDotViewModel()) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
    }
    required init?(coder: NSCoder) {
        self.viewModel = ViewModelType()
        super.init(coder: coder)
        setupViews()
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size = CGSize(width: viewModel.totalWidth, height: viewModel.config.size)
        return size
    }
    
    override var intrinsicContentSize: CGSize {
        let size = CGSize(width: viewModel.totalWidth, height: viewModel.config.size)
        self.delegate?.dotSizeChange(size)
        return size
    }
    
    deinit {
        cancellables.forEach({ $0.cancel() })
    }
}

private extension CHPhotosDotView {
    func bindViewModel() {
        // 配置变化绑定
        viewModel.$config
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.handleConfigChange()
            }
            .store(in: &cancellables)
        // 动画状态绑定 removeDuplicates 避免重复值触发，dropFirst 不触发初始值
        viewModel.$isAnimating
            .removeDuplicates()
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAnimating in
                isAnimating ? self?.startAnimation() : self?.stopAnimation()
            }
            .store(in: &cancellables)
    }
    func handleConfigChange() {
        // 自动更新布局
        invalidateIntrinsicContentSize()
        updateLayout()
        restartAnimationIfNeeded()
    }
}

extension CHPhotosDotView {
    func setupDotViews() {
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews.removeAll()
        var xPosition: CGFloat = 0
        for _ in 0 ..< viewModel.config.numberOfDots {
            let dot = UIView()
            dot.backgroundColor = viewModel.config.activeColor
            dot.layer.cornerRadius = viewModel.config.size / 2
            dot.frame = CGRect(
                x: xPosition,
                y: 0,
                width: viewModel.config.size,
                height: viewModel.config.size
            )
            addSubview(dot)
            dotViews.append(dot)
            xPosition += viewModel.config.size + viewModel.config.spacing
        }
        resetDots()
    }
    
    func updateLayout() {
        setNeedsLayout()
        layoutIfNeeded()
    }
    func restartAnimationIfNeeded() {
        if viewModel.isAnimating {
            stopAnimation()
            startAnimation()
        }
    }
}

private extension CHPhotosDotView {
    func setupViews() {
        setupDotViews()
        bindViewModel()
    }
    
    func resetDots() {
        UIView.animate(withDuration: 0.3) {
            self.dotViews.forEach { dot in
                dot.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                dot.backgroundColor = self.viewModel.config.inactiveColor
            }
        }
    }
    func animateDots() {
        guard viewModel.isAnimating else { return }
        for (index, dot) in dotViews.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) { [weak self] in
                guard let self = self, self.viewModel.isAnimating else { return }
                dot.layer.removeAllAnimations()
                dot.transform = .identity
                if index == self.dotViews.count - 1 {
                    self.resetDots()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        if self.viewModel.isAnimating {
                            self.animateDots()
                        }
                    }
                }
            }
        }
    }
    func startAnimation() {
        viewModel.animation(true)
        animateDots()
    }
    func stopAnimation() {
        viewModel.animation(false)
        resetDots()
    }
}
