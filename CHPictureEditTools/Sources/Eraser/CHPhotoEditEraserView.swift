//
//  PhotoEditPreviewView.swift
//  FFmpegDemo
//  橡皮擦的视图
//  Created by apple on 2024/5/16.
//

import UIKit


enum PhotoEditEraserChangeState {
    case start
    case changing
    case end
}

typealias PhotoEditEraserChangeBlock = (_ isStart: PhotoEditEraserChangeState, _ image: UIImage?) -> Void

class CHPhotoEditEraserView: CHBasePhotoEditPrview, UIGestureRecognizerDelegate {
    /// 是否是擦除,如果是擦除就会将图片擦掉，否则的话就将颜色填充选择的位置   true , false
    var isEraset = true
    var historyIndexCut: Int! = 0
    // 图片显示的尺寸(会根据当前的尺寸绘画显示的视图)
    var showSize: CGSize = .zero
    var showImage: UIImage! {
        didSet {
            showImageView.image = showImage
            layoutSubviews()
        }
    }
    func editEraserChange(with block: @escaping PhotoEditEraserChangeBlock) {
        editEraserChange = block
    }
    /// 移动过的痕迹存储（抬起后为一次）
    private(set) var historyList: [[CGRect]] = []
    /// 单次移动的历史记录
    private var sigleHistoryList: [CGRect] = []
    /// 橡皮擦的大小
    var eraserSize: CGFloat = 10
    /// 使用橡皮擦功能完成
    private var editEraserChange: PhotoEditEraserChangeBlock?
    /// 是否触碰
    private var isTouch = false
    /// 手势的触碰
    private var swipeGesture: UIPanGestureRecognizer!
    override var editImage: UIImage! {
        didSet {
            showImage = editImage
        }
    }
    override func setupUI() {
        super.setupUI()
        // 添加滑动手势到 UIView
        swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.delegate = self
        self.addGestureRecognizer(swipeGesture)
    }
    /// 取消绘画
    func cancelDrawList() {
        historyList = []
    }
    
    /// 截取指定索引的数据
    func cutIndexData(_ index: Int) {
        if isEraset == false {
            var nowIndex = index
            if nowIndex > 0 {
                if historyList.count == 0 {
                    return
                }
                if nowIndex > self.historyList.count  - 1 {
                    nowIndex = self.historyList.count - 1
                }
                historyList = Array(self.historyList[..<nowIndex])
            } else {
                historyList = []
            }
            print("change index: \(nowIndex)")
        }
    }
    
}

private extension CHPhotoEditEraserView {
    @objc func handleSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        if isEnabel == false { return }
        // 如果需要获取手势当前在视图中的具体坐标，可以用以下代码
        let location = gesture.location(in: self)
        if gesture.numberOfTouches == 1 {
            if gesture.state == .began {
                isTouch = true
                editEraserChange?(.start, nil)
            } else if gesture.state == .changed {
                erase(at: location)
                editEraserChange?(.changing, nil)
            }
        }
        // 只有手指触碰的标识为true并且状态为结束状态
        if isTouch == true && gesture.state == .ended {
            isTouch = false
            // 将这一次的移动数据添加到主数组中，添加后将单个的历史记录清空
            historyList.append(sigleHistoryList)
            sigleHistoryList = []
            if isEraset == false {
                applyEraserHistory()
            }
            
            editEraserChange?(.end, showImage)
        }
    }
    
    // 擦除功能
    func erase(at point: CGPoint) {
        guard let showImage = showImage else { return }
        UIGraphicsBeginImageContextWithOptions(showImage.size, false, showImage.scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        showImage.draw(in: CGRect(origin: .zero, size: showImage.size))
        let scale = showImage.size.width / self.bounds.width
        let imagePoint = CGPoint(x: point.x * scale, y: point.y * scale)
        // 得到在画布中应该得到的直径数值
        var canvasEraserSize = eraserSize
        if showSize != .zero {
            // 计算缩放比例
            let scaleRatio = showImage.size.width / showSize.width
            // 转换后的圆点大小
            canvasEraserSize = eraserSize * scaleRatio
        }
        let pointRect = CGRect(
            x: imagePoint.x - canvasEraserSize / 2,
            y: imagePoint.y - canvasEraserSize / 2,
            width: canvasEraserSize,
            height: canvasEraserSize
        )
        //        Log.d("当前App展示的绘画尺寸为:\(eraserSize),实际绘画到图片的尺寸为:\(canvasEraserSize),图片实际大小:\(showImage.size),实际在App中显示的大小:\(showSize)")
        // 创建手指触碰的区域
        let eraserPath = UIBezierPath(ovalIn: pointRect)
        // 添加历史记录可用于上传勾选的区域
        sigleHistoryList.append(pointRect)
        // 判断是否为擦除的状态
        if isEraset {
            context.setBlendMode(.clear)
        } else {
            context.setBlendMode(.normal)
            let selFillColor = UIColor(red: 0.0706, green: 0.5882, blue: 0.8588, alpha: 0.15)
            context.setFillColor(selFillColor.cgColor)
        }
        // 添加绘画的路径
        context.addPath(eraserPath.cgPath)
        context.fillPath()
        // 获取新的 Image 对象
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            
            self.showImage = newImage // Update the image
        }
    }
    /// 应用
    func applyEraserHistory() {
        guard let showImage = editImage else { return }
        UIGraphicsBeginImageContextWithOptions(showImage.size, false, showImage.scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        showImage.draw(in: CGRect(origin: .zero, size: showImage.size))
        let strokeColor = UIColor(red: 0.0706, green: 0.5882, blue: 0.8588, alpha: 0.65).cgColor
        context.setStrokeColor(strokeColor)
        for (_, item) in historyList.enumerated() {
            context.setLineCap(.round)
            context.beginPath()
            for (sIndex, sItem) in item.enumerated() {
                context.setLineWidth(sItem.width)
                let point = CGPoint(x: sItem.origin.x + sItem.width / 2.0, y: sItem.origin.y + sItem.height / 2.0)
                if sIndex == 0 {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
            }
            context.strokePath()
        }
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            self.showImage = newImage // Update the image
        }
    }
    
}
