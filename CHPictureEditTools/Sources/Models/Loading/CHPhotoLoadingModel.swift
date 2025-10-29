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
    let animationDuration: TimeInterval
    
    static let `default` = CHPhotoLoadingModel(
        tip: "",
        bottomTip: "",
        mainColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9),
        tipColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
        tipFont: .systemFont(ofSize: 14),
        bottomColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
        bottomFont: .systemFont(ofSize: 12),
        animationDuration: 0.35
    )
}

extension CHPhotoLoadingModel {
    struct Builder {
        var tip: String?
        var bottomTip: String?
        var mainColor: UIColor?
        var tipColor: UIColor?
        var tipFont: UIFont?
        var bottomColor: UIColor?
        var bottomFont: UIFont?
        var animationDuration: TimeInterval?
        func build(defaultModel: CHPhotoLoadingModel = .default) -> CHPhotoLoadingModel {
            CHPhotoLoadingModel(
                tip: tip ?? defaultModel.tip,
                bottomTip: bottomTip ?? defaultModel.bottomTip,
                mainColor: mainColor ?? defaultModel.mainColor,
                tipColor: tipColor ?? defaultModel.tipColor,
                tipFont: tipFont ?? defaultModel.tipFont,
                bottomColor: bottomColor ?? defaultModel.bottomColor,
                bottomFont: bottomFont ?? defaultModel.bottomFont,
                animationDuration: animationDuration ?? defaultModel.animationDuration
            )
        }
    }
}
