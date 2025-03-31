//
//  CHPhotoLoadingModel.swift
//  CHPictureEditTools
//
//  Created by DG on 2025/3/27.
//

import UIKit

struct CHPhotoLoadingModel {
    let tip: String
    let bottomTip: String
    let mainColor: UIColor
    let tipColor: UIColor
    let tipFont: UIFont
    let bottomColor: UIColor
    let bottomFont: UIFont
    
    static let `default` = CHPhotoLoadingModel(
        tip: "",
        bottomTip: "",
        mainColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9),
        tipColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
        tipFont: .systemFont(ofSize: 14),
        bottomColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
        bottomFont: .systemFont(ofSize: 12)
    )
}

extension CHPhotoLoadingModel {
    struct Builder {
        // 所有属性改为 Optional
        var tip: String?
        var bottomTip: String?
        var mainColor: UIColor?
        var tipColor: UIColor?
        var tipFont: UIFont?
        var bottomColor: UIColor?
        var bottomFont: UIFont?
        // 添加显式无参初始化器
//        init() {}
        func build(defaultModel: CHPhotoLoadingModel = .default) -> CHPhotoLoadingModel {
            CHPhotoLoadingModel(
                tip: tip ?? defaultModel.tip,
                bottomTip: bottomTip ?? defaultModel.bottomTip,
                mainColor: mainColor ?? defaultModel.mainColor,
                tipColor: tipColor ?? defaultModel.tipColor,
                tipFont: tipFont ?? defaultModel.tipFont,
                bottomColor: bottomColor ?? defaultModel.bottomColor,
                bottomFont: bottomFont ?? defaultModel.bottomFont
            )
        }
    }
}
