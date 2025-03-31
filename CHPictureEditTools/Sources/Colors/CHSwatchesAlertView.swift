//
//  CHSwatchesAlertView.swift
//  ClickFree
//
//  Created by apple on 2024/6/22.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import UIKit

class CHSwatchesAlertView: CHBaseAlertView {
    init() {
        super.init(frame: .zero)
        setupUI()
        setupAlertContentUI()
        self.isHidden = true
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupAlertContentUI()
        self.isHidden = true
    }
    func onSelectedClickColor(with block: @escaping (_ color: UIColor) -> Void) {
        onSelectedClickColor = block
    }
    
    override func buttonsAction(button: UIButton) {
        if button == mBtnConfirm, let color = mSelectColor {
            onSelectedClickColor?(color)
        }
        hiddenView()
    }
    
    override func setupAlertContentUI() {
        super.setupAlertContentUI()
        // 更改主要容器的布局
        mMainContentView.snp.remakeConstraints({
            $0.trailing.leading.bottom.equalToSuperview()
        })
        mContentStackView.insertArrangedSubview(mMainView, at: 0)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        mMainContentView.setCorners(corners: [.topLeft, .topRight], radius: 12)
        //        mImgBackground.cornerRadius = mImgBackground.frame.height / 2.0
        circleCenter = CGPoint(x: mImgBackground.bounds.midX, y: mImgBackground.bounds.midY)
        circleRadius = mImgBackground.frame.width / 2.0
    }
    private lazy var mMainView: UIView = {
        let view = UIView()
        view.addSubview(mImgBackground)
        mImgBackground.snp.makeConstraints({
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.centerX.equalToSuperview()
        })
        return view
    }()
    // 创建色板
    private lazy var mImgBackground: UIImageView = {
        let image = UIImageView(image: UIImage.loadImage("img_color_select"))
        image.addSubview(mImgPoint)
        image.isUserInteractionEnabled = true
        // 添加滑动手势识别器
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        // 添加点击手势
        let tapPicker = UITapGestureRecognizer(target: self, action: #selector(touchHandle(_:)))
        image.addGestureRecognizer(panGesture)
        image.addGestureRecognizer(tapPicker)
        return image
    }()
    // 选中的指示器
    private lazy var mImgPoint: UIImageView = {
        let image = UIImageView(image: UIImage.loadImage("Combined Shape"))
        image.frame = CGRect(x: 0, y: 0, width: 48, height: 54)
        image.addSubview(mSelColorView)
        image.isHidden = true
        mSelColorView.center.x = image.frame.width / 2.0
        return image
    }()
    // 选中的颜色视图
    private lazy var mSelColorView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 6, width: 32, height: 32))
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    private var circleCenter: CGPoint = .zero
    private var circleRadius: CGFloat = 0
    private var onSelectedClickColor: ((_ color: UIColor) -> Void)?
    private var mSelectColor: UIColor!
}

private extension CHSwatchesAlertView {
    
    @objc func touchHandle(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: mImgBackground)
        if distance(from: location, to: circleCenter) <= self.circleRadius {
            if let color = getPixelColor(at: location) {
                mSelectColor = color
                changePointShow(location, color: color)
            }
        }
    }
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let location = gestureRecognizer.location(in: mImgBackground)
        switch gestureRecognizer.state {
        case .changed:
            if distance(from: location, to: circleCenter) <= self.circleRadius {
                if let color = getPixelColor(at: location) {
                    mSelectColor = color
                    changePointShow(location, color: color)
                }
            }
        default:
            break
        }
    }
    
    func changePointShow(_ point: CGPoint, color: UIColor) {
        mImgPoint.isHidden = false
        mImgPoint.center = CGPoint(x: point.x , y: point.y - (mImgPoint.frame.height / 2.0))
        mSelColorView.backgroundColor = color
    }
    
    /// 根据手指的位置得到当前位置的颜色值
    /// - Parameter point: 手指点击坐标的位置
    /// - Returns: 当前位置的颜色
    func getPixelColor(at point: CGPoint) -> UIColor? {
        guard let image = mImgBackground.image else { return nil }
        let size = image.size
        let scale = image.scale
        // 确保触摸点在图片范围内
        guard point.x >= 0 && point.x < size.width &&
                point.y >= 0 && point.y < size.height else { return nil }
        let cgImage = image.cgImage!
        let data = cgImage.dataProvider!.data
        let dataPtr = CFDataGetBytePtr(data)
        let bytesPerPixel = 4
        let bytesPerRow = cgImage.bytesPerRow
        let bytesOffset = Int(point.y * scale) * bytesPerRow + Int(point.x * scale) * bytesPerPixel
        let colorR = CGFloat(dataPtr![bytesOffset]) / 255.0
        let colorG = CGFloat(dataPtr![bytesOffset + 1]) / 255.0
        let colorB = CGFloat(dataPtr![bytesOffset + 2]) / 255.0
        let colorA = CGFloat(dataPtr![bytesOffset + 3]) / 255.0
        return UIColor(red: colorR, green: colorG, blue: colorB, alpha: colorA)
    }
    // 计算两点之间的距离
    func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let dx = point1.x - point2.x
        let dy = point1.y - point2.y
        return sqrt(dx * dx + dy * dy)
    }
    
}

private extension UIView {
    /// 设置视图的圆角
    /// - Parameters:
    ///   - corners: 需要设置圆角的角，例如 [.topLeft, .topRight]
    ///   - radius: 圆角的半径
    func setCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
