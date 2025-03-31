//
//  CHPhotoEditToolsCell.swift
//  ClickFree
//
//  Created by apple on 2024/6/20.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import UIKit

class CHPhotoEditToolsCell: UICollectionViewCell {

    static let identify = "CHPhotoEditToolsCell"
    @IBOutlet weak var mLayoutImgTop: NSLayoutConstraint!
    @IBOutlet weak var mMainView: UIView!
    @IBOutlet weak var mLabTitle: UILabel!
    @IBOutlet weak var mImgLogo: UIImageView!
    
    /// 更新数据
    /// - Parameters:
    ///   - type: 当前的类型
    ///   - isSel: 是否选中
    func updateData(_ type: CHPhotoEditType, isSel: Bool = false) {
        resetStyle()
        let model = type.model
        let showImg = isSel ? model.imageSelName : model.imageNorName
        mImgLogo.image = UIImage.loadImage(showImg ?? "")
        mLabTitle.text = model.title ?? ""
        mLabTitle.textColor = !isSel ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.3137254902, green: 0.6, blue: 0.9921568627, alpha: 1)
    }
    /// 更新列表数据
    func updateImage(imgName: String, isSel: Bool = false) {
        resetStyle()
        // 换装的显示
        mImgLogo.image = UIImage.loadImage(imgName)
        mImgLogo.layer.cornerRadius = 4
        mImgLogo.layer.masksToBounds = true
        mImgLogo.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mImgLogo.contentMode = .scaleAspectFill
    }
    func updateImage(img: UIImage, isSel: Bool = false) {
        resetStyle()
        mImgLogo.image = img
        mImgLogo.contentMode = .center
        mImgLogo.layer.cornerRadius = 4
        mImgLogo.layer.masksToBounds = true
    }
    func updateImage(_ type: CHPhotoEditSizeType, isSel: Bool = false) {
        resetStyle()
        // 尺寸改变的数据
        let model = type.model
        mImgLogo.image = UIImage.loadImage(isSel ? model.imageNorName : model.imageSelName)
        mLabTitle.text = model.title
        mLabTitle.textColor = isSel ? #colorLiteral(red: 0.3137254902, green: 0.3137254902, blue: 0.3137254902, alpha: 1) : #colorLiteral(red: 0.737254902, green: 0.737254902, blue: 0.737254902, alpha: 1)
        mLabTitle.font = .systemFont(ofSize: 12)
        mMainView.layer.cornerRadius = 12
        mMainView.layer.masksToBounds = true
        mMainView.backgroundColor = isSel ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : .clear
        mLayoutImgTop.constant = 15
    }
    func resetStyle() {
        mLayoutImgTop.constant = 0
        mMainView.layer.cornerRadius = 0
        mImgLogo.backgroundColor = .clear
        mLabTitle.text = ""
        mImgLogo.image = nil
        mMainView.backgroundColor = .clear
    }
}
