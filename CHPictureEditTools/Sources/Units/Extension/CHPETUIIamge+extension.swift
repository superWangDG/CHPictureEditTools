//
//  CHPETUIIamge+extension.swift
//  CHPictureEditTools
//
//  Created by apple on 2025/3/3.
//

import UIKit
extension UIImageView {
    
}

extension UIImage {
    static func loadImage(_ named: String) -> UIImage? {
        UIImage(named: named, in: CHConstConfig.default().resouceBundle, compatibleWith: nil)
    }
}


