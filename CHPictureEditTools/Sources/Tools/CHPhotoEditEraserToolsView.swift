//
//  CHPhotoEditEraserToolsView.swift
//  ClickFree
//  橡皮擦工具
//  Created by apple on 2024/6/23.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import UIKit

typealias EraserToolsChangeSizeBlock = (_ size: CGFloat) -> Void

typealias EraserToolsOnClickButtonsBlock = (_ button: PhotoEditEraserToolsButton) -> Void

// 擦除工具栏的点击按钮事件
enum PhotoEditEraserToolsButton {
    case undo
    case submit
}

class CHPhotoEditEraserToolsView: UIView, UIGestureRecognizerDelegate {
    /// 是否能够拖拽进度条
    var isTouchDrap = true
    /// 橡皮擦的大小
    var eraserSize: CGFloat = 60 {
        didSet {
            setCurrentProgress(eraserSize / maxEraserSize)
            self.mLabShowSize.text = "\(Int(eraserSize))"
        }
    }
    /// 橡皮擦最大的大小
    var maxEraserSize: CGFloat = 100 {
        didSet {
            setCurrentProgress(eraserSize / maxEraserSize)
        }
    }
    /// 橡皮擦大小改变
    func eraserToolsChangeBlock(with block: @escaping EraserToolsChangeSizeBlock) {
        mEraserToolsChangeBlock = block
    }
    /// 按钮的事件
    func eraserToolsOnClickButtonsBlock(with block: @escaping EraserToolsOnClickButtonsBlock) {
        mEraserToolsOnClickButtonsBlock = block
    }
    /// 设置当前的进度条
    /// - Parameter value: 0 - 1
    func setCurrentProgress(_ value: CGFloat) {
        if isDraging { return }
        var proportion = value
        if proportion > 1 {
            proportion = 1
        }
        DispatchQueue.main.async {
            self.mCurrentProgressView.snp.updateConstraints({
                $0.width.equalTo(proportion * self.mMainDrapView.frame.size.width)
            })
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // 设置手势的优先级，要求某个手势在另一个手势失败后才能识别
        if gestureRecognizer is UITapGestureRecognizer && otherGestureRecognizer is UIPanGestureRecognizer {
            return true
        }
        return false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // 设置手势的优先级，要求某个手势在另一个手势识别失败前不能识别
        if gestureRecognizer is UIPanGestureRecognizer && otherGestureRecognizer is UITapGestureRecognizer {
            return true
        }
        return false
    }
    /// 主视图
    private(set) lazy var mMainDrapView: UIView = {
        let view = UIView()
//        view.backgroundColor = .red
        view.isUserInteractionEnabled = true
        view.addSubview(mMainProgressView)
        view.addSubview(mCurrentProgressView)
        mMainProgressView.snp.updateConstraints({
            $0.centerY.left.right.equalToSuperview()
            $0.height.equalTo(4)
        })
        mCurrentProgressView.snp.updateConstraints({
            $0.centerY.left.equalToSuperview()
            $0.width.equalTo(0)
            $0.height.equalTo(mMainProgressView)
        })
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(movedChange))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.delegate = self
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    private(set) lazy var mPointView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.shadowRadius = 3
        view.layer.shadowColor = #colorLiteral(red: 0.3568627451, green: 0.6156862745, blue: 0.9882352941, alpha: 0.4).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        return view
    }()
    // 背景容器
    private(set) lazy var mMainProgressView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 2
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
        return view
    }()
    // 当前进度
    private(set) lazy var mCurrentProgressView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 2
        view.backgroundColor = #colorLiteral(red: 0.03529411765, green: 0.5411764706, blue: 0.9490196078, alpha: 1)
        return view
    }()
    private(set) lazy var mBtnUndo: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(NSLocalizedString("Undo", comment: ""), for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1.0), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .disabled)
        button.setImage(UIImage.loadImage("ic_undo"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.contentHorizontalAlignment = .left
        button.isEnabled = false
        button.addTarget(self, action: #selector(undoAction), for: .touchUpInside)
        return button
    }()
    private(set) lazy var mBtnSubmit: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(NSLocalizedString("Submit", comment: ""), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.03529411765, green: 0.537254902, blue: 0.9490196078, alpha: 1), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.contentHorizontalAlignment = .right
        button.isEnabled = false
        button.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        return button
    }()
    private(set) var mLabTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = NSLocalizedString("Brush_size", comment: "")
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    private(set) var mLabShowSize: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "0"
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .right
        return label
    }()
    // 是否正在拖拽的标识，避免正在拖拽时 UI 界面的变化
    private var isDraging = false
    /// 拖拽后的进度回调
    private var mEraserToolsChangeBlock: EraserToolsChangeSizeBlock?
    private var mEraserToolsOnClickButtonsBlock: EraserToolsOnClickButtonsBlock?
}
private extension CHPhotoEditEraserToolsView {
    @objc func undoAction() {
        mEraserToolsOnClickButtonsBlock?(.undo)
    }
    @objc func submitAction() {
        mEraserToolsOnClickButtonsBlock?(.submit)
    }
    func setupUI() {
        addSubview(mBtnUndo)
        addSubview(mBtnSubmit)
        addSubview(mLabTitle)
        addSubview(mMainDrapView)
        addSubview(mPointView)
        addSubview(mLabShowSize)
        mBtnUndo.snp.makeConstraints({
            $0.left.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(12)
            $0.width.equalTo(160)
            $0.height.equalTo(35)
        })
        mBtnSubmit.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-30)
            $0.centerY.equalTo(mBtnUndo)
        })
        mLabTitle.snp.makeConstraints({
            $0.left.equalTo(mBtnUndo)
            $0.top.equalTo(mBtnUndo.snp.bottom).offset(15)
            $0.right.equalToSuperview().offset(-30)
            $0.height.equalTo(20)
        })
        mMainDrapView.snp.makeConstraints({
            $0.left.equalTo(mBtnUndo)
            $0.top.equalTo(mLabTitle.snp.bottom).offset(-15)
            $0.right.equalToSuperview().offset(-80)
            $0.height.equalTo(80)
        })
        mLabShowSize.snp.makeConstraints( {
            $0.top.bottom.equalTo(mMainDrapView)
            $0.right.equalToSuperview().offset(-30)
            $0.left.equalTo(mMainDrapView.snp.right).offset(5)
        })
        mPointView.snp.makeConstraints({
            $0.width.height.equalTo(20)
            $0.centerY.equalTo(mCurrentProgressView)
            $0.centerX.equalTo(mCurrentProgressView.snp.right)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            self.setCurrentProgress(self.eraserSize / self.maxEraserSize)
            self.mLabShowSize.text = "\(Int(self.eraserSize))"
        })
    }
    @objc func handleTap(tap: UITapGestureRecognizer) {
        if !isTouchDrap {
            return
        }
        let point = tap.location(in: self.mMainDrapView)
        mCurrentProgressView.snp.updateConstraints({
            $0.width.equalTo(point.x)
        })
        eraserSize = (point.x / mMainDrapView.frame.width) * maxEraserSize
        mEraserToolsChangeBlock?(eraserSize)
    
    }
    // 手指移动
    @objc func movedChange(tap: UIGestureRecognizer) {
        if !isTouchDrap {
            return
        }
        var point = tap.location(in: self.mMainDrapView)
        // 手指在范围内才能够拖动
        if point.x > self.frame.width {
            point.x = self.frame.width
        }
        if point.x < 1 {
            point.x = 1
        }
        if tap.state == .changed {
            mCurrentProgressView.snp.updateConstraints({
                $0.width.equalTo(point.x)
            })
            eraserSize = (point.x / mMainDrapView.frame.width) * maxEraserSize
        } else if tap.state == .began {
            isDraging = true
        } else if tap.state == .ended {
            if tap is UITapGestureRecognizer {
                // 如果是点击的情况再完成的时候同时进行进度条的改变
                mCurrentProgressView.snp.updateConstraints({
                    $0.width.equalTo(point.x)
                })
            }
            isDraging = false
            mEraserToolsChangeBlock?(eraserSize)
        }
    }
}
