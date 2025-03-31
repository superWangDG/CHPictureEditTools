//
//  CHPhotosDotModel.swift
//  CHPictureEditTools
//
//  Created by DG on 2025/3/27.
//

import UIKit

struct CHPhotosDotModel {
    let size: CGFloat
    let spacing: CGFloat
    let activeColor: UIColor
    let inactiveColor: UIColor
    let animationDuration: TimeInterval
    let delayBetweenAnimations: TimeInterval
    let numberOfDots: Int
    
    static let `default` = CHPhotosDotModel(
        size: 12.0,
        spacing: 9.0,
        activeColor: UIColor(red: 0.31, green: 0.6, blue: 0.99, alpha: 1),
        inactiveColor: UIColor(red: 0.31, green: 0.6, blue: 0.99, alpha: 0.3),
        animationDuration: 1.0,
        delayBetweenAnimations: 1.0,
        numberOfDots: 3
    )
}

extension CHPhotosDotModel {
    struct Builder {
        var size: CGFloat?
        var spacing: CGFloat?
        var activeColor: UIColor?
        var inactiveColor: UIColor?
        var animationDuration: TimeInterval?
        var delayBetweenAnimations: TimeInterval?
        var numberOfDots: Int?
        
        func build(defaultModel: CHPhotosDotModel = .default) -> CHPhotosDotModel {
            return CHPhotosDotModel(
                size: size ?? defaultModel.size,
                spacing: spacing ?? defaultModel.spacing,
                activeColor: activeColor ?? defaultModel.activeColor,
                inactiveColor: inactiveColor ?? defaultModel.inactiveColor,
                animationDuration: animationDuration ?? defaultModel.animationDuration,
                delayBetweenAnimations: delayBetweenAnimations ?? defaultModel.delayBetweenAnimations,
                numberOfDots: numberOfDots ?? defaultModel.numberOfDots
            )
        }
    }
}
