//
//  CHPhotoEditHandleModel.swift
//  ClickFree
//
//  Created by apple on 2024/6/21.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import Foundation
import ZLPhotoBrowser

class CHPhotoEditHandleModel: NSObject {
    
    // 编辑图片的历史记录
    private var imageRecordList: [UIImage] = []
    // 历史记录当前的索引
    private var recordIndex = 0
    /// 当前替换背景的图片
    private var mBackgroundImage: UIImage!
    /// 改变画布的尺寸，zero 不使用改变
    private var mChangeCanvasSize: CGSize = .zero
    /// 改变画布显示的比例 0 不使用
    private var mChangeCanvasRatio: CGFloat = 0
    /// 是否能够拖动图片
    private var isDarpImageEnabel = true
    /// 原本图片偏移的位置记录
    private var positionOffset: CGPoint = .zero
    /// 视图层
    private weak var view: CHPhotoEditHandleView!
    /// 是否完成第一次AI图片的处理
    private var isFristRequestHandle = false
    /// 照片管理
//    let photoManager = CHAIPhotoEditManager()
    /// 图片修复编辑的历史记录
    private var retouchImageList: [UIImage] = []
    // 历史记录查看的索引
    private var retouchSeeIndex = 0
    // 换装的字段
    private var dressKey: String? = nil
    // 换装颜色透明
    private var dressBgColor = "00000000"
    // 回调管理
    private var callbackManager: CHPhotoEditHandleCallback!
    /// 加载中显示的尺寸描述文本
    private var mLoadingSizeDes: String?
    
    init(view: CHPhotoEditHandleView!) {
        super.init()
        self.view = view
        callbackManager = CHPhotoEditHandleCallback(rootView: view, model: self)
    }
    
//    func setupDataModel(_ dataModel: AIRootManagerModel.AIRootManagerSubModel) {
//        self.dataModel = dataModel
//        callbackManager.setupDataModel(dataModel)
//        initDataModel()
//    }
  
    /// 打开色板选择指定颜色
    func openSwatchesView() {
        let alert = CHSwatchesAlertView()
        alert.onSelectedClickColor { [weak self]color in
//            self?.replaceBackgroundImage(color.image(), isColor: true)
        }
        alert.showView()
    }
    /// 获取图片随机的名称
    func getImageRandomName(image: UIImage) -> String {
        return image.randomImageName()
    }
    /// 打开相册选择背景图片
    func openPictureView() {
//        openPhotos()
    }
    /// 取消背景图片的设置
    func clearBackgroundImage() {
        mBackgroundImage = nil
//        withStateGenerateImage()
    }
    /// 替换背景图片
    func replaceBackgroundImage(_ image: UIImage, isColor: Bool = false) {
        mBackgroundImage = image
//        withStateGenerateImage()
    }
    /// 设置画布的大小
    func resetCanvasSize(_ size: CGSize) {
//        mChangeCanvasSize = size
//        if dataModel.type == .passport {
//            // 护照类型改变画布大小
//            getCacheImage { [weak self] in
//                self?.requestNetDressData()
//            }
//        } else {
//            withStateGenerateImage()
//        }
    }
    /// 改变当前画布的尺寸
//    func changeImageRatioCanvas(_ type: CHPhotoEditSizeType) {
//        
//        switch type {
//        case .original:
//            mChangeCanvasSize = view.originalImage?.size ?? .zero
//            mChangeCanvasRatio = 0
//        case .customize:
//            // 跳转设置尺寸的页面
//            let alert = CHAIPhotosCustomSizesView(
//                title: NSLocalizedString("Custom_sizes", comment: "")
//            )
//            alert.onClickBlock = { [weak self] (view, isConfirm, reslut) in
//                if isConfirm, let values = reslut?.split(separator: ",")  {
//                    let width = String(values[0])
//                    let height = String(values[1])
//                    let size = CGSize(width: Double(width) ?? 0 , height: Double(height) ?? 0 )
//                    // 使用得到的尺寸
//                    self?.mChangeCanvasSize = size
//                    self?.mChangeCanvasRatio = 0
//                    self?.withStateGenerateImage()
//                }
//                view.hiddenView()
//            }
//            alert.showView()
//            break
//        case .passport1:
//            mChangeCanvasRatio = 16.0 / 9.0
//            //            mChangeCanvasSize = view.showImage?.getSizeWithRatio(16.0 / 9.0) ?? .zero
//        case .passport2:
//            mChangeCanvasRatio = 9.0 / 16.0
//            //            mChangeCanvasSize = view.showImage?.getSizeWithRatio(9.0 / 16.0) ?? .zero
//        case .passport3:
//            mChangeCanvasRatio = 3.0 / 4.0
//            //            mChangeCanvasSize = view.showImage?.getSizeWithRatio(3.0 / 4.0) ?? .zero
//        case .passport4:
//            mChangeCanvasRatio = 4.0 / 3.0
//            //            mChangeCanvasSize = view.showImage?.getSizeWithRatio(4.0 / 3.0) ?? .zero
//        }
////        withStateGenerateImage()
//        
//    }
    /// 替换衣服
    /// - Parameters:
    ///   - imageName: 衣服的图片名
    ///   - key: 衣服的Key
//    func replaceDressImage(_ imageName: String, key: String) {
//        dressKey = key
//        getCacheImage(saveOriginal: true) { [weak self] in
//            self?.requestNetDressData()
//        }
//    }
    /// 获取画布尺寸的描述
//    func getCanvasSizeText(model: CHAIUseSizeModel) -> String {
//        if let sizeStr = model.description.split(separator: "\n").last {
//            let value = String(sizeStr)
//            guard value.count >= 2 else {
//               Log.i("字符串长度不足以进行操作")
//                return value
//            }
//            // 移除第一个和最后一个字符
//            let startIndex = value.index(after: value.startIndex)
//            let endIndex = value.index(before: value.endIndex)
//            let newStr = String(value[startIndex..<endIndex])
//            return newStr
//        }
//        return model.description
//    }
    /// 请求首次Ai图片处理
//    func requestInitImageHandle(_ saveOriginal: Bool = false) {
//        Log.d("正在调用")
//        if !isFristRequestHandle {
//            view.loadingHandleImage()
//            // 获取缓存中的图片。如果无法获取的情况下直接使用请求的方式获取初始的图片
//            if let imgName = view.mImageName {
//                var size: CGSize? = nil
//                if dataModel.type == .passport {
//                    // 使用图片尺寸设置Key值
//                    size = dataModel.canvasModel == .custom ? mChangeCanvasSize : dataModel.canvasModel.canvasPixelSize()
//                }
//                var newName = getHandleImageName(orgName: imgName, mainType: dataModel.type, size: size)
//                if dataModel.type == .passport {
//                    newName = getNowImageName()
//                }
//                Log.d("获取首次的默认图名称:\(newName)")
//                photoManager.getCacheImage(newName, orgImage: self.view.originalImage) { [weak view, weak self]image in
//                    if let img = image {
//                        // 不需要首次处理
//                        view?.resetShowImage(img)
//                        if saveOriginal {
//                            view?.resetOriginalImage(img)
//                        }
//                        view?.loadingHandleImage(true)
//                        UIApplication.topViewController()?.showSucceedToast(.successStr)
//                    } else {
//                        self?.requestNetInitImageHandle()
//                    }
//                }
//            } else {
//                // 直接请求图片的处理（并生成图片的名称）
//                requestNetInitImageHandle()
//            }
//            isFristRequestHandle = true
//        }
//    }
    /// 开始生成图片
//    func withStateGenerateImage() {
//        var nowImg = view.originalImage
//        nowImg = nowImg?.withDraw(
//            backgroundImage: mBackgroundImage,
//            canvasSize: mChangeCanvasSize,
//            movePoint: positionOffset,
//            ratio: mChangeCanvasRatio,
//            startCenter: dataModel.type == .passport ? true : false
//        )
//        if let img = nowImg {
//            view.resetShowImage(img)
//        }
//    }
    /// 上一步的逻辑处理
    func undoLogicHandle() {
        if recordIndex > 0 {
            recordIndex -= 1
        } else {
            if retouchImageList.count > 0 {
                retouchSeeIndex -= 1
                if retouchSeeIndex <= 0 {
                    retouchSeeIndex = 0
                }
                view.resetShowImage(retouchImageList[retouchSeeIndex])
                view.mEditEraserToolsView.mBtnUndo.isEnabled = retouchSeeIndex > 0
                return
            }
        }
        // 如果recordIndex索引不是最后
        if recordIndex > 0 {
            // 舍弃当前索引之后的数据
            imageRecordList = Array(imageRecordList[...recordIndex])
        } else {
            imageRecordList = [view.originalImage!]
        }
        setEraserCutIndex(recordIndex)
        view.resetShowImage(imageRecordList[recordIndex])
        view.mEditEraserToolsView.mBtnUndo.isEnabled = recordIndex > 0
    }
    /// 获取当前图片的名字
    func getNowImageName() -> String {
        let key = self.view.mImageName ?? ""
        var childType = self.view.mEditLinkToolsView.mToolsType
        // 设置获取图片尺寸的情况
        var size: CGSize? = nil
//        if dataModel.type == .passport {
//            // 如果当前是证件照的类型并且,Size 不为空的情况下降当前的类型赋值 Size
//            if mChangeCanvasSize != .zero {
//                childType = .size
//            }
//            // 使用图片尺寸设置Key值
//            size = dataModel.canvasModel == .custom ? mChangeCanvasSize : dataModel.canvasModel.canvasPixelSize()
//        }
//        let newName = self.getHandleImageName(
//            orgName: key,
//            mainType: dataModel.type,
//            childType: childType,
//            bgColor: dataModel.type == .passport ? dressBgColor : nil,
//            dressKey: dressKey,
//            size: size
//        )
//        return newName
        return ""
    }
    /// 设置画笔的大小
    func eraserSizeChangeLogicHandle(_ size: CGFloat) {
        view.mContentMainView.eraserSizeChangeLogicHandle(size)
    }
    /// 橡皮擦移动完成后的逻辑处理
    func eraserChangeLogicHandle(_ image: UIImage) {
//        if imageRecordList.count == 0 {
//            imageRecordList.append(self.view.originalImage!)
//        }
//        imageRecordList.append(image)
//        recordIndex = imageRecordList.count - 1
//        resetEditEraserToolsViewBtnStatus()
    }
    // 提交使用橡皮擦选择的图片路径
    func submitEraserRecordList() {
//        guard let dataModel = dataModel , let view = view else { return }
//        let dictList = getEraserHistory()
//        // 封装数据
//        let sendModel = AIFlieRequestModel(
//            fileData: view.originalImage?.pngData(),
//            aiId: dataModel.serviceModel?.id ?? "",
//            rectangles: dictList
//        )
//        resetEditEraserToolsViewBtnStatus(false)
//        NetwrokManager.shared.requst(.aiImageretouch(parameters: sendModel), responseModel: ResponseModel<String>.self, reslutBlock: { [weak self]result in
//            guard let self = self else { return }
//            if !(result.data ?? "").isEmpty {
//                self.photoManager.downloadImage(result.data ?? "", with: { [weak self]image in
//                    DispatchQueue.main.async {
//                        if let img = image {
//                            UIApplication.topViewController()?.showSucceedToast(.successStr)
//                            self?.view.resetShowImage(img)
//                            // 清除橡皮擦的记录
//                            self?.recordIndex = 0
//                            self?.clearEraserHistory()
//                            self?.view.mEditEraserToolsView.mBtnSubmit.isEnabled = false
//                            if (self?.retouchSeeIndex ?? 0) > 0 {
//                                // 舍弃当前索引之后的数据
//                                self?.retouchImageList = Array(self?.imageRecordList[...(self?.retouchSeeIndex ?? 0)] ?? [])
//                            }
//                            self?.retouchImageList.append(img)
//                            
//                            // 最后一张图的索引地址
//                            self?.retouchSeeIndex = (self?.retouchImageList.count ?? 0) - 1
//                        }
//                        self?.view.loadingHandleImage(true)
////                        self?.resetEditEraserToolsViewBtnStatus()
//                    }
//                })
//            } else {
//                // 初始化得到的图片失败
//                self.view.loadingHandleImage(true)
//                self.resetEditEraserToolsViewBtnStatus()
//            }
//            Log.d("当前使用图像修饰后的图片地址是:\(result.data ?? "")")
//        }, failureBlock: { [weak self]error in
//            self?.resetEditEraserToolsViewBtnStatus()
//            self?.view.loadingHandleImage(true)
//            self?.view.errorBlock?(error.errorDescription ?? "")
//        })
    }
    /// 移动图片的距离
    func movingFrontImage(_ point: CGPoint) {
        positionOffset = point
        // 开始绘画移动后的图形
//        withStateGenerateImage()
    }
}

fileprivate extension CHPhotoEditHandleModel {
    // 设置橡皮擦工具栏按钮是否可用的状态
    func resetEditEraserToolsViewBtnStatus(_ enable: Bool? = nil) {
        if let enable = enable  {
            view.mEditEraserToolsView.mBtnSubmit.isEnabled = enable
            view.mEditEraserToolsView.mBtnUndo.isEnabled = enable
        } else {
            view.mEditEraserToolsView.mBtnSubmit.isEnabled = imageRecordList.count > 0
//            let edit = recordIndex > 0 ? imageRecordList.count > 0 : retouchImageList.count > 0
            view.mEditEraserToolsView.mBtnUndo.isEnabled = imageRecordList.count > 0
        }
    }
    
    /// 初始化数据模型
    func initDataModel() {
//        Log.d("进入初始化照片编辑的模型中...")
//        guard let dataSource = dataModel, let view = view else { return }
//        switch dataSource.type {
//        case .retouch:
//            view.mEditToolsView.isHidden = true
//            view.mEditEraserToolsView.isHidden = false
//        case .cutout, .passport, .remover:
//            view.mEditToolsView.mSourceModel = dataSource
//            view.mEditEraserToolsView.isHidden = true
//            if dataSource.type == .passport {
//                let customSizeDes = "\(view.mCanvasSize.width)*\(view.mCanvasSize.height) px"
//                let fixSizeDes = getCanvasSizeText(model: dataSource.canvasModel)
//                let description = dataSource.canvasModel == .custom ? customSizeDes : fixSizeDes
//                mLoadingSizeDes = description
//            }
//            // 测试加载视图
//            requestInitImageHandle(true)
//        default:
//            break
//        }
//        let isMove = dataSource.type == .remover || dataSource.type == .cutout
//        view.mContentMainView.setMoveTouch(isMove)
//        view.mContentMainView.setEraserSize(view.mEditEraserToolsView.eraserSize)
//        setEraserEnable()
//        Log.d("是否能够移动:\(isMove)")
    }
    /// 得到图片刷新UI
    /// - Parameter notImageBlock: 没有得到图片触发回调
    func getCacheImage(saveOriginal: Bool = false, with notImageBlock: @escaping () -> Void) {
        let name = getNowImageName()
        view.loadingHandleImage()
//        photoManager.getCacheImage(name) { [weak self]image in
//            if let img = image {
//                UIApplication.topViewController()?.showSucceedToast(.successStr)
//                // 不需要首次处理
//                self?.view.resetShowImage(img)
//                if saveOriginal {
//                    self?.view.resetOriginalImage(img)
//                }
//                self?.view.loadingHandleImage(true)
//                self?.withStateGenerateImage()
//            } else {
//                notImageBlock()
//            }
//        }
    }
    /// 下载的图片显示
    func downloadImageSave(_ path: String, key: String? = nil, saveOriginal: Bool = false) {
        if !path.isEmpty {
//            UIApplication.topViewController()?.showSucceedToast(.successStr)
//            
//            var imageName = key
//            if imageName == nil {
//                imageName = getNowImageName()
//            }
//            // 获取存储的图片
//            self.photoManager.downloadImage(path, key: imageName, orgImage: self.view.originalImage, with: { [weak self]image in
//                DispatchQueue.main.async {
//                    if let img = image {
//                        self?.view.resetShowImage(img)
//                        if saveOriginal {
//                            self?.view.resetOriginalImage(img)
//                        }
////                        if self?.dataModel.type == .passport {
////                            self?.withStateGenerateImage()
////                        }
//                    } else {
//                        // 下载失败
//                        Log.d("下载失败")
//                        self?.view.errorBlock?(NSLocalizedString("Generation_Failure", comment: ""))
//                    }
//                    self?.view.loadingHandleImage(true)
//                }
//            })
        } else {
            // 初始化得到的图片失败
            view.loadingHandleImage(true)
        }
    }
    /// 网络请求图片首次处理
//    func requestNetInitImageHandle() {
//        guard let img = view.originalImage, let dataModel = dataModel else { return }
//        Log.d("请求网络预处理图片")
//        //        mSourceModel.type == .cutout || mSourceModel.type == .passport || mSourceModel.type == .remover
//        var model = AIFlieRequestModel(fileData: img.pngData() ?? Data(), aiId: dataModel.serviceModel.id)
//        var api: CHApi!
//        switch dataModel.type {
//        case .cutout:
//            api = .aiFacecutout(parameters: model)
//        case .passport:
//            // 使用 600x600 的尺寸 生成初始的图片
//            var size = dataModel.canvasModel.canvasPixelSize()
//            if dataModel.canvasModel == .custom {
//                size = view.mCanvasSize
//            }
//            model.pxHeight = size.height
//            model.pxWidth = size.width
//            model.bgColor = dressBgColor
//            api = .aiPassportphoto(parameters: model)
//            break
//        case .remover:
//            api = .aiBackgroundremover(parameters: model)
//        default:
//            break
//        }
//        if api == nil {
//            Log.d("暂不支持的功能:\(dataModel.type.description)")
//            return
//        }
//        // 如果当前图片没有名字的话先赋值图片名字
//        view.resetImageName(self.view.originalImage?.randomImageName() ?? "")
//        
//        NetwrokManager.shared.requst(api, responseModel: ResponseModel<String>.self, reslutBlock: { [weak self]result in
//            guard let self = self else { return }
//            let key = self.view.mImageName ?? ""
//            let newName = self.getHandleImageName(orgName: key, mainType: dataModel.type)
//            self.downloadImageSave(result.data ?? "", key: dataModel.type == .passport ? nil : newName, saveOriginal: true)
//        },failureBlock: { [weak self]error in
//            self?.view?.loadingHandleImage(true)
//            self?.view?.errorBlock?(error.errorDescription ?? "")
//        })
//    }
    /// 请求换装
    /// - Parameter dressKey: 换装衣服的Key
//    func requestNetDressData() {
//        guard let img = view.originalImage, let dataModel = dataModel else { return }
//        
//        // 获取本地是否存在当前的图片
//        var model = AIFlieRequestModel(fileData: img.pngData() ?? Data(), aiId: dataModel.serviceModel.id)
//        var size = dataModel.canvasModel.canvasPixelSize()
//        if dataModel.canvasModel == .custom {
//            size = view.mCanvasSize
//        }
//        model.pxHeight = size.height
//        model.pxWidth = size.width
//        model.bgColor = dressBgColor
//        model.dress = dressKey
//        view.loadingHandleImage()
//        NetwrokManager.shared.requst(.aiPassportphoto(parameters: model), responseModel: ResponseModel<String>.self, reslutBlock: { [weak self]result in
//            guard let self = self else { return }
//            self.downloadImageSave(result.data ?? "", saveOriginal: true)
//        },failureBlock: { [weak self]error in
//            self?.view.loadingHandleImage(true)
//            self?.view.errorBlock?(error.errorDescription ?? "")
//        })
//    }
    
    /// 打开相机
//    func openCamera() {
//        let vc = CHImagePickerController()
//        vc.sourceType = .camera
//        vc.onSelectedImage = { [weak self ] image in
//            guard let self = self else {return}
//            self.replaceBackgroundImage(image)
//        }
//        UIApplication.getKeyWindow()?.rootViewController?.present(vc, animated: true)
//    }
    /// 打开相册
//    func openPhotos() {
//        let previewSheet = ZLPhotoPreviewSheet()
//        previewSheet.selectImageBlock = { [weak self]reslustModels,isOriginal in
//            guard let self = self else {return}
//            let image = reslustModels.first?.image ?? UIImage()
//            self.replaceBackgroundImage(image)
//        }
//        if let controller = UIApplication.getKeyWindow()?.rootViewController {
//            previewSheet.showPhotoLibrary(sender: controller)
//        }
//    }
    /// 获取处理得到的图片名称
    func getHandleImageName(
        orgName: String,
        mainType: String,
        childType: CHPhotoEditType? = nil,
        bgColor: String? = nil,
        dressKey: String? = nil,
        size: CGSize? = nil
    ) -> String {
        var value = orgName
        let list = value.split(separator: ".")
        var lastValue = ""
        if list.count >= 2 {
            // 逻辑是删除最后一个数组的数据,之后将所有数组的字符串拼接为一个字符串
            lastValue = String(list.last ?? "")
            value = list.dropLast().joined()
        }
        value.append("_\(mainType)")
        if let childType = childType {
            value.append("_\(childType.rawValue)")
            if let bgColor = bgColor {
                value.append("_\(bgColor)")
            }
            if let dressKey = dressKey {
                value.append("_\(dressKey)")
            }
        }
        if let size = size, size != .zero {
            value.append("_\(Int(size.width))x\(Int(size.height))")
        }
        if lastValue.isEmpty {
            return value
        }
        return "\(value).\(lastValue)"
    }
    func getEraserHistory() -> [[String: CGFloat]] {
        view.mContentMainView.getEraserHistory()
    }
    func clearEraserHistory() {
        view.mContentMainView.clearEraserHistory()
    }
    func setEraserCutIndex(_ index: Int) {
        view.mContentMainView.setEraserCutIndex(index)
    }
    // 设置是否能够使用涂抹的功能
    func setEraserEnable(_ isEnable: Bool) {
        view.mContentMainView.setEraserEnable(isEnable)
    }
}


private extension UIImage {
    /// 根据比例得到计算当前的图片得到的额尺寸
    func getSizeWithRatio(_ ratio: CGFloat) -> CGSize {
        // 获取原始图像的尺寸
        let originalSize = self.size
        // 计算16:9的新尺寸
        var newWidth = originalSize.width
        var newHeight = originalSize.height
        
        if originalSize.width / originalSize.height > ratio {
            // 宽度比高度宽，需要调整宽度
            newWidth = originalSize.height * ratio
        } else {
            // 高度比宽度高，需要调整高度
            newHeight = originalSize.width / ratio
        }
        return CGSize(width: newWidth, height: newHeight)
    }
    /// 根据宽度来缩放的计算
    func scaleSize(originalSize: CGSize, targetWidth: CGFloat) -> CGSize {
        let scaleFactor = targetWidth / originalSize.width
        let newHeight = originalSize.height * scaleFactor
        return CGSize(width: targetWidth, height: newHeight)
    }
    /// 根据宽度来缩放的计算
    func scaleSize(originalSize: CGSize, targetHeight: CGFloat) -> CGSize {
        let scaleFactor = targetHeight / originalSize.height
        let newWidth = originalSize.width * scaleFactor
        return CGSize(width: newWidth, height: targetHeight)
    }
    /// 根据比例得到计算当前的图片得到的额尺寸
    func getSizeWithRatio(_ ratio: CGFloat, originalSize: CGSize) -> CGSize {
        // 计算新尺寸
        var newWidth = originalSize.width
        var newHeight = originalSize.height
        if originalSize.width / originalSize.height > ratio {
            // 宽度比高度宽，需要调整宽度
            newWidth = originalSize.height * ratio
        } else {
            // 高度比宽度高，需要调整高度
            newHeight = originalSize.width / ratio
        }
        return CGSize(width: newWidth, height: newHeight)
    }
    /// 绘制图片
    /// - Parameters:
    ///   - backgroundImage: 背景图片
    ///   - canvasSize: 画布大小
    ///   - movePoint: 前置图片移动的距离
    ///   - opaque: 是否透明，默认透明
    ///   - startCenter: 是否根据画布居中显示
    func withDraw(
        backgroundImage: UIImage? = nil,
        canvasSize: CGSize = .zero,
        movePoint: CGPoint = .zero,
        ratio: CGFloat = 0,
        startCenter: Bool = false,
        opaque: Bool = false
    ) -> UIImage? {
        var imageSize = size
        // 如果背景图存在，判断背景图是否为纯色图并且画布大小没有限制
//        if let backImg = backgroundImage, !CHAIPhotoEditManager.checkImageIsColor(backImg) && canvasSize == .zero {
//            // 判断背景图的宽高大于绘制图片的宽高的情况使用背景图的宽高
//            if backImg.size.width >= size.width && backImg.size.height >= size.height {
//                imageSize = backImg.size
//            }
//        }
        if canvasSize != .zero {
            imageSize = canvasSize
        }
        
        if ratio != 0 {
            // 得到比例的尺寸
            imageSize = getSizeWithRatio(ratio, originalSize: imageSize)
        }
        // 开始图形上下文
        UIGraphicsBeginImageContextWithOptions(imageSize, opaque, 0)
        guard UIGraphicsGetCurrentContext() != nil else { return nil }
        
        // 如果有背景图片，先绘制背景
        if let backgroundImage = backgroundImage {
            var bgSize = scaleSize(originalSize: backgroundImage.size, targetWidth: imageSize.width)
            if bgSize.height < imageSize.height {
                // 高度小于的情况使用高度进行拉伸
                bgSize = scaleSize(originalSize: backgroundImage.size, targetHeight: imageSize.height)
            }
            let bgRect = CGRect(origin: .zero, size: bgSize)
//            if backgroundImage.size.width > imageSize.width || backgroundImage.size.height > imageSize.height {
//                // 背景图片大于画布，计算居中显示的位置
//                let scale = max(imageSize.width / backgroundImage.size.width, imageSize.height / backgroundImage.size.height)
//                let scaledWidth = backgroundImage.size.width * scale
//                let scaledHeight = backgroundImage.size.height * scale
//                let x = (imageSize.width - scaledWidth) / 2
//                let y = (imageSize.height - scaledHeight) / 2
//                bgRect = CGRect(x: x, y: y, width: scaledWidth, height: scaledHeight)
//            } else {
//                // 背景图片小于或等于画布，直接填充
//                bgRect = CGRect(origin: .zero, size: imageSize)
//            }
            backgroundImage.draw(in: bgRect)
        }
        // 计算当前图片的绘制位置
        var orgImagePoint = movePoint
        if startCenter {
            let offx = (self.size.width - imageSize.width) / 2.0
            orgImagePoint = CGPoint(x: -offx, y: 0)
        }
        var rect = CGRect(origin: orgImagePoint, size: self.size)
//        if ratio != 0 {
//            Log.d("显示的图片Y坐标超出")
            // 得到有效的图片坐标以及图片的大小
//            let rect = CHAIPhotoEditManager.getImageEfficientRect(self)
            var newSize = scaleSize(originalSize: self.size, targetWidth: imageSize.width)
            if ratio > 1 {
                newSize = scaleSize(originalSize: self.size, targetHeight: imageSize.height)
            }
            rect.size = newSize
//        }
        
        
        // 绘制当前图片
        self.draw(in: rect)
        
        // 获取生成的新图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 结束图形上下文
        UIGraphicsEndImageContext()
        
        return newImage
    }
    /// 随机生成图片名称并识别为 PNG 或 JPEG
    func randomImageName() -> String {
        // 生成随机字符串
        let uuid = UUID().uuidString
        // 根据图片格式生成文件后缀
        var fileExtension: String
        if let _ = self.pngData() {
            fileExtension = "png"
        } else if let _ = self.jpegData(compressionQuality: 1.0) {
            fileExtension = "jpeg"
        } else {
            // 如果既不是 PNG 也不是 JPEG
            fileExtension = ""
        }
        if fileExtension.isEmpty {
            return uuid
        }
        // 拼接文件名和后缀
        return "\(uuid).\(fileExtension)"
    }
}
fileprivate extension String {
    static var successStr: String { NSLocalizedString("Successfully_Generated", comment: "") }
}
