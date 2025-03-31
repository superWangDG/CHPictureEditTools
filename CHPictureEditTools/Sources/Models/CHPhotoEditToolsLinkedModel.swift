//
//  CHPhotoEditToolsLinkedModel.swift
//  ClickFree
//
//  Created by apple on 2024/6/21.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import UIKit

typealias ChooseToolsLinkedColorBlock = (_ type: CHPhotoEditColorType) -> Void
typealias ChooseToolsLinkedContextsBlock = (_ type: CHPhotoEditContextsType) -> Void
typealias ChooseToolsLinkedDressBlock = (_ key: String, _ imgName: String, _ imgSelName: String) -> Void
typealias ChooseToolsLinkedSizeBlock = (_ type: CHPhotoEditSizeType) -> Void

class CHPhotoEditToolsLinkedModel: NSObject {
    private weak var view: CHPhotoEditToolsLinkedView!
    var chooseColorBlock: ChooseToolsLinkedColorBlock?
    var chooseContextsBlock: ChooseToolsLinkedContextsBlock?
    var chooseDressBlock: ChooseToolsLinkedDressBlock?
    var chooseSizeBlock: ChooseToolsLinkedSizeBlock?
    
    private(set) var colorCellIdentity = "colorCellIdentity"
    private(set) var sizeCellIdentity = "sizeCellIdentity"
    private(set) var contextsCellIdentity = "contextsCellIdentity"
    private(set) var dressCellIdentity = "dressCellIdentity"
    private var mDataColorList = CHPhotoEditType.color.linkList as? [CHPhotoEditColorType] ?? []
    private var mDataContextsList = CHPhotoEditType.contexts.linkList as? [CHPhotoEditContextsType] ?? []
    private var mDataSizeList = CHPhotoEditType.size.linkList as? [CHPhotoEditSizeType] ?? []
    private var mColorIndex: IndexPath? = nil
    private var mContextsIndex: IndexPath? = nil
    private var mSizeIndex: IndexPath? = nil
    private var mDressIndex: IndexPath? = nil
    
    init(view: CHPhotoEditToolsLinkedView) {
        self.view = view
    }
    func getCellCount(_ collectionView: UICollectionView) -> Int {
        switch collectionView {
        case view.mCollectionSizeView: return mDataSizeList.count
        case view.mCollectionColorView: return mDataColorList.count
        case view.mCollectionContextsView: return mDataContextsList.count
        case view.mCollectionDressView: return view.dressDataList[view.mDressCurrentIndex].imageNames.count
        default: return 0
        }
    }
    func getCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        var cell: CHPhotoEditToolsCell!
        switch collectionView {
        case view.mCollectionSizeView:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: sizeCellIdentity, for: indexPath) as? CHPhotoEditToolsCell
        case view.mCollectionColorView:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: colorCellIdentity, for: indexPath) as? CHPhotoEditToolsCell
        case view.mCollectionContextsView:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: contextsCellIdentity, for: indexPath) as? CHPhotoEditToolsCell
        case view.mCollectionDressView:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: dressCellIdentity, for: indexPath) as? CHPhotoEditToolsCell
        default: break
        }
        guard let cell = cell else { return UICollectionViewCell() }
        var isSel = false
        
        var image: UIImage!
        if collectionView == view.mCollectionColorView {
            if mSizeIndex != nil && indexPath.row == mSizeIndex?.row {
                isSel = true
            }
            image = mDataColorList[indexPath.row].image
        } else if collectionView == view.mCollectionDressView {
            if mDressIndex != nil && indexPath.row == mDressIndex?.row {
                isSel = true
            }
            let dressList = view.dressDataList[view.mDressCurrentIndex].imageNames ?? []
            cell.updateImage(imgName: dressList[indexPath.row], isSel: isSel)
        } else if collectionView == view.mCollectionContextsView  {
            if mContextsIndex != nil && indexPath.row == mContextsIndex?.row {
                isSel = true
            }
            image = mDataContextsList[indexPath.row].image
        } else if collectionView == view.mCollectionSizeView  {
            if mSizeIndex != nil && indexPath.row == mSizeIndex?.row {
                isSel = true
            }
            cell.updateImage(mDataSizeList[indexPath.row], isSel: isSel)
        }
        if image != nil {
            cell.updateImage(img: image!, isSel: isSel)
        }
        return cell
    }
    func getCellSize(_ collectionView: UICollectionView) -> CGSize {
        let height = collectionView.frame.height
        if view.mToolsType != .size {
            return CGSize(width: 45, height: 45)
        } else {
            return CGSize(width: 65, height: 90)
        }
    }
    func chooseCell(_ collectionView: UICollectionView, indexPath: IndexPath) {
        if collectionView == view.mCollectionColorView {
            chooseColorBlock?(mDataColorList[indexPath.row])
            mColorIndex = indexPath
        } else if collectionView == view.mCollectionDressView {
            let data = view.dressDataList[view.mDressCurrentIndex]
            let imgName = data.imageNames[indexPath.row]
            let imgSelName = data.showImageNames[indexPath.row]
            let key = data.imageKeys[indexPath.row]
            mDressIndex = indexPath
            chooseDressBlock?(key, imgName, imgSelName)
        } else if collectionView == view.mCollectionContextsView {
            mContextsIndex = indexPath
            chooseContextsBlock?(mDataContextsList[indexPath.row])
        } else if collectionView == view.mCollectionSizeView {
            mSizeIndex = indexPath
            chooseSizeBlock?(mDataSizeList[indexPath.row])
        }
    }
    // 改变布局
    func changeCollectionLayout() {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumInteritemSpacing = view.mToolsType == .size ? 0 : 12
//        view.mCollectionView.setCollectionViewLayout(layout, animated: true)
//        view.mCollectionView.snp.updateConstraints({
//            $0.height.equalTo(view.mToolsType == .size ? 90 : 45)
//        })
    }
}

