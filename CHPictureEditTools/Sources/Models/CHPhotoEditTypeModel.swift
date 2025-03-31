//
//  CHPhotoEditTypeModel.swift
//  ClickFree
//
//  Created by apple on 2024/6/20.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import UIKit

// 编辑工具栏选择方式回调(type为空取消选择)
typealias PhotoEditToolsTypeSelect = (_ type: CHPhotoEditType?) -> Void

// MARK: - 工具视图枚举
enum CHPhotoEditType: String {
    // 背景颜色
    case color
    // 换装
    case dress
    // 尺寸选择
    case size
    // 背景图片以及颜色
    case contexts
    // 根据当前类型获取不同的对象数据
    var model: CHPhotoEditTypeModel {
        switch self {
        case .color:
            return CHPhotoEditTypeModel(
                imageNorName: "ic_passport_color_def",
                imageSelName: "ic_passport_color_sel",
                title: NSLocalizedString("Color", comment: "")
            )
        case .dress:
            return CHPhotoEditTypeModel(
                imageNorName: "ic_passport_dress_def",
                imageSelName: "ic_passport_dress_sel",
                title: NSLocalizedString("Dress", comment: "")
            )
        case .size:
            return CHPhotoEditTypeModel(
                imageNorName: "ic_passport_size_def",
                imageSelName: "ic_passport_size_sel",
                title: NSLocalizedString("Size", comment: "")
            )
        case .contexts:
            return CHPhotoEditTypeModel(
                imageNorName: "ic_remover_bg_def",
                imageSelName: "ic_remover_bg_sel",
                title: NSLocalizedString("Contexts", comment: "")
            )
        }
    }
    /// 获取当前类型链接的数据列表 (换装的数据需要单独处理)
    var linkList: [Any] {
        switch self {
        case .color: return CHPhotoEditColorType.allCases
        case .dress: return []
        case .size: return CHPhotoEditSizeType.allCases
        case .contexts: return CHPhotoEditContextsType.allCases
        }
    }
}
struct CHPhotoEditTypeModel {
    // 默认状态
    var imageNorName: String!
    // 选中状态
    var imageSelName: String!
    // 显示的状态
    var title: String!
}
// MARK: - 联动视图 Contexts 枚举
enum CHPhotoEditContextsType: String, CaseIterable {
    // 图片背景
    case picture
    // 透明背景
    case transparent
    // 色板背景
    case swatches
    // 颜色背景
    case colorFAADAD
    case colorFDD5A5
    case colorA0C4FF
    // 得到图片（UIImage）
    var image: UIImage? {
        switch self {
        case .picture: return UIImage.loadImage("ic_photo_ai_def")
        case .transparent: return UIImage.loadImage("transparent_background")
        case .swatches: return UIImage.loadImage("img_color_select")
        case .colorFAADAD: return #colorLiteral(red: 0.9803921569, green: 0.6784313725, blue: 0.6784313725, alpha: 1).image()
        case .colorFDD5A5: return #colorLiteral(red: 0.9921568627, green: 0.8352941176, blue: 0.6470588235, alpha: 1).image()
        case .colorA0C4FF: return #colorLiteral(red: 0.6274509804, green: 0.768627451, blue: 1, alpha: 1).image()
        }
    }
    
}
// MARK: - 联动视图 Size 枚举
enum CHPhotoEditSizeType: String, CaseIterable {
    case original
    case customize
    /// 16:9
    case passport1
    /// 9:16
    case passport2
    /// 4:3
    case passport3
    /// 3:4
    case passport4
    var model: CHPhotoEditTypeModel {
        switch self {
        case .original:
            return CHPhotoEditTypeModel(imageNorName: "ic_size_original_nor", imageSelName: "ic_size_original_sel", title: "Original")
        case .customize:
            return CHPhotoEditTypeModel(imageNorName: "ic_size_customize_nor", imageSelName: "ic_size_customize_sel", title: "Customize")
        case .passport1:
            return CHPhotoEditTypeModel(imageNorName: "ic_passport_16_9", imageSelName: "ic_passport_16_9", title: "Size 1")
        case .passport2:
            return CHPhotoEditTypeModel(imageNorName: "ic_passport_9_16", imageSelName: "ic_passport_9_16", title: "Size 2")
        case .passport3:
            return CHPhotoEditTypeModel(imageNorName: "ic_passport_4_3", imageSelName: "ic_passport_4_3", title: "Size 3")
        case .passport4:
            return CHPhotoEditTypeModel(imageNorName: "ic_passport_3_4", imageSelName: "ic_passport_3_4", title: "Size 4")
        }
    }
}
// MARK: - 联动视图 Color 枚举
enum CHPhotoEditColorType: String, CaseIterable {
    // 色板背景
    case swatches
    // 透明背景
    case transparent
    // 颜色值
    case colorF70502
    case color438EDB
    case colorFFFFFF
    case color2B385B
    // 得到图片（UIImage）
    var image: UIImage? {
        switch self {
        case .transparent: return UIImage.loadImage("transparent_background")
        case .swatches: return UIImage.loadImage("img_color_select")
        case .colorF70502: return #colorLiteral(red: 0.968627451, green: 0.01960784314, blue: 0.007843137255, alpha: 1).image()
        case .color438EDB: return #colorLiteral(red: 0.262745098, green: 0.5568627451, blue: 0.8588235294, alpha: 1).image()
        case .colorFFFFFF: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).image()
        case .color2B385B: return #colorLiteral(red: 0.168627451, green: 0.2196078431, blue: 0.3568627451, alpha: 1).image()
        }
    }
}
// MARK: - 换装的 对象
class ClothingModel: NSObject {
    var title: String!
    var imageNames: [String]!
    /// 用于替换服装的图片(在未使用OpenCV的情况下不使用当前的字段,此字段的图片适用于本地替换衣服)
    var showImageNames: [String]!
    /// 上传服装的Key
    var imageKeys: [String]!
    /// 获取换装对象的列表
    class func getModelList() -> [ClothingModel] {
        let titles = [
            NSLocalizedString("Men", comment: ""),
            NSLocalizedString("Women", comment: ""),
            NSLocalizedString("Children", comment: ""),
        ]
        var list: [ClothingModel] = []
        for item in titles {
            let model = ClothingModel()
            model.title = item
            var maxCount = 0
            var prefixName = ""
            var prefixKey = ""
            switch item {
            case titles[0]:
                prefixName = "man_"
                prefixKey = "man"
                maxCount = 28
            case titles[1]:
                prefixName = "woman_"
                prefixKey = "woman"
                maxCount = 18
            case titles[2]:
                prefixName = "child_"
                prefixKey = "child"
                maxCount = 16
            default:
                break
            }
            var names: [String] = []
            var showList: [String] = []
            var keys: [String] = []
            for index in 1 ... maxCount {
                let name = "\(prefixName)\(index)"
                names.append(name)
                keys.append("\(prefixKey)\(index)")
                showList.append("\(name)_crop")
            }
            model.imageNames = names
            model.showImageNames = showList
            model.imageKeys = keys
            list.append(model)
        }
        return list
    }
}

private extension UIColor {
    func image(_ isMinSize: Bool = false) -> UIImage {
        let size = isMinSize ? CGSize(width: 1, height: 1) : CGSize(width: 1000, height: 1000)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
