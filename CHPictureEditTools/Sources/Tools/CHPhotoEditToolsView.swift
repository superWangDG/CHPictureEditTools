//
//  CHPhotoEditToolsView.swift
//  ClickFree
//
//  Created by apple on 2024/6/20.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import UIKit

class CHPhotoEditToolsView: UIView {

    // 传入主对象数据源使用类型 remover、cutout、passport
//    var mSourceModel: AIRootManagerModel.AIRootManagerSubModel! {
//        didSet {
//            if mSourceModel.type == .remover || mSourceModel.type == .cutout {
//                self.mDataList = [.contexts, .size]
//            } else if mSourceModel.type == .passport {
//                self.mDataList = [.color, .dress]
//            }
//            mCollectionView.reloadData()
//        }
//    }
    // 工具类型选择
    func toolsTypeBlock(with block:@escaping PhotoEditToolsTypeSelect) {
        toolsTypeBlock = block
    }
    /// 取消选择的样式
    func cancelChoose() {
        mCurrentIndex = nil
        mCollectionView.reloadData()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    private func setupUI() {
        addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }

    private var toolsTypeBlock: PhotoEditToolsTypeSelect?
    private var mDataList: [CHPhotoEditType] = []
    // 当前选中的索引
    private var mCurrentIndex: IndexPath!
    private lazy var mCollectionView: UICollectionView = {
        let layout = CHAlignCollectionFlowLayout()
        layout.align = .left
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView.register(UINib(nibName: CHPhotoEditToolsCell.identify, bundle: .main), forCellWithReuseIdentifier: CHPhotoEditToolsCell.identify)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
}

extension CHPhotoEditToolsView: UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mDataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CHPhotoEditToolsCell! = collectionView.dequeueReusableCell(withReuseIdentifier: CHPhotoEditToolsCell.identify, for: indexPath) as? CHPhotoEditToolsCell
        var isSel = false
        if mCurrentIndex != nil && indexPath.row == mCurrentIndex.row {
            isSel = true
        }
        cell.updateData(mDataList[indexPath.row], isSel: isSel)
//        cell.mLabTitle.font =  mSourceModel.type == .passport ? .systemFont(ofSize: 18, weight: .medium) : .systemFont(ofSize: 14)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 选中了数据
        if mCurrentIndex != nil && indexPath.row == mCurrentIndex.row {
            // 取消选中的逻辑
            mCurrentIndex = nil
        } else {
            // 正常的逻辑情况赋值选中的索引
            mCurrentIndex = indexPath
        }
        collectionView.reloadData()
        var type: CHPhotoEditType?
        if mCurrentIndex != nil {
            type = mDataList[mCurrentIndex.row]
        }
        toolsTypeBlock?(type)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: collectionView.frame.height)
    }
}
