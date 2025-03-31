//
//  CHPhotoEditHandleCallback.swift
//  ClickFree
//
//  Created by apple on 2024/6/29.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import Foundation
import UIKit

class CHPhotoEditHandleCallback: NSObject {
    
    private weak var rootView: CHPhotoEditHandleView!
    private weak var model: CHPhotoEditHandleModel!
//    private var dataModel: AIRootManagerModel.AIRootManagerSubModel!
    
    
    init(rootView: CHPhotoEditHandleView!, model: CHPhotoEditHandleModel) {
        super.init()
        self.rootView = rootView
        self.model = model
        registerCallback()
    }
//    func setupDataModel(_ dataModel: AIRootManagerModel.AIRootManagerSubModel) {
//        self.dataModel = dataModel
//    }

    private func registerCallback() {
        guard let view = rootView, let model = model else { return }
        // 显示子选项
        view.mEditToolsView.toolsTypeBlock { [weak self, weak view]type in
            guard let self = self, let view = view else { return }
//            if dataModel.type == .passport && type == .size {
//                // 使用选择页面的尺寸选择
//                view.canvasSizeChooseBlock?()
//                view.mEditToolsView.cancelChoose()
//                view.mEditLinkToolsView.isHidden = true
//                return
//            }
            view.mEditLinkToolsView.mToolsType = type
            view.mEditLinkToolsView.isHidden = type == nil ? true : false
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            //                self?.view.updateContentLayout()
            //            })
        }
        // 工具栏改变橡皮擦的大小
        view.mEditEraserToolsView.eraserToolsChangeBlock { [weak model]size in
            model?.eraserSizeChangeLogicHandle(size)
        }
        // 尺寸替换点击回调
        view.mEditLinkToolsView.chooseSizeBlock { [weak model]type in
//            model?.changeImageRatioCanvas(type)
        }
        // 颜色选择回调
        view.mEditLinkToolsView.chooseColorBlock { [weak model]type in
            if type == .swatches {
                model?.openSwatchesView()
            }
            //            else if type == .transparent {
            //                self.model.clearBackgroundImage()
            //            }
            else {
                model?.replaceBackgroundImage(type.image ?? UIImage(), isColor: true)
            }
        }
        // 背景颜色以及图片选择
        view.mEditLinkToolsView.chooseContextsBlock { [weak model]type in
            if type == .swatches {
                model?.openSwatchesView()
            } else if type == .picture {
                model?.openPictureView()
            } else if type == .transparent {
                model?.clearBackgroundImage()
            } else {
                model?.replaceBackgroundImage(type.image ?? UIImage())
            }
        }
        // 服装选择回调
        view.mEditLinkToolsView.chooseDressBlock { [weak model]key, imgName, imgSelName in
//            model?.replaceDressImage(imgName , key: key)
        }
        // 涂抹功能完成一次操作
        view.mContentMainView.editEraserChange { [weak model] isStart, image in
            if isStart == .end, let image = image {
                model?.eraserChangeLogicHandle(image)
            }
        }
        view.mEditEraserToolsView.eraserToolsOnClickButtonsBlock { [weak model, weak view] button in
            if button == .undo {
                model?.undoLogicHandle()
            } else {
                // 提交当前操作后的图片
                view?.loadingHandleImage()
                model?.submitEraserRecordList()
            }
        }
        // 当前置的图片发生了移动
        view.mContentMainView.movingChangeBlock { [weak model] isChanging, offPoint in
            model?.movingFrontImage(offPoint)
        }
    }
}
