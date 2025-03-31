//
//  CHPETUIColor+extension.swift
//  CHPictureEditTools
//
//  Created by DG on 2025/3/25.
//

import UIKit

extension UIColor {
    
    /// hex 设置颜色
    convenience init(hex: Int32 ,alpha:CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255
        let blue = CGFloat((hex & 0x0000FF)) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    convenience init?(hexString: String,alpha:CGFloat = 1.0) {
        var hexStr: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexStr.hasPrefix("#") {
            hexStr.removeFirst()
        }
        if #available(iOS 13.0, *) {
            guard hexStr.count == 6, let hexNumber = Scanner(string: hexStr).scanInt32() else {
                return nil
            }
            self.init(hex: hexNumber,alpha: alpha)
        } else {
            guard hexStr.count == 6 else {
                return nil
            }
            var hexNumber: UInt32 = 0
            Scanner(string: hexStr).scanHexInt32(&hexNumber)
            self.init(hex: Int32(hexNumber),alpha: alpha)
        }
    }
}
