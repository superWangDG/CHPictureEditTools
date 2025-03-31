//
//  CHPhotoEditToolsLinkedView.swift
//  ClickFree
//  工具视图的联动视图
//  Created by apple on 2024/6/21.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import UIKit

class CHPhotoEditToolsLinkedView: UIView {
    // 当前换装下选中的类型索引
    var mDressCurrentIndex: Int = 0
    // 当前选中的工具类型
    var mToolsType: CHPhotoEditType? {
        didSet {
            if let type = mToolsType {
                setToolsType(type)
            }
        }
    }
    // MARK: - 选择功能回调
    func chooseColorBlock(with block:@escaping ChooseToolsLinkedColorBlock) {
        model?.chooseColorBlock = block
    }
    func chooseContextsBlock(with block:@escaping ChooseToolsLinkedContextsBlock) {
        model?.chooseContextsBlock = block
    }
    func chooseDressBlock(with block:@escaping ChooseToolsLinkedDressBlock) {
        model?.chooseDressBlock = block
    }
    func chooseSizeBlock(with block:@escaping ChooseToolsLinkedSizeBlock) {
        model?.chooseSizeBlock = block
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    private(set) var mMainStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        return stackView
    }()
    
    private(set) var mDataList: [Any] = []
    //    // 当前选中的索引
    //    private(set) var mCurrentIndex: IndexPath!
    //
    private(set) lazy var mBtnLeftArrow: UIButton = {
        let button = UIButton(type: .custom)
        let norColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let disColor = #colorLiteral(red: 0.2470588235, green: 0.2, blue: 0.337254902, alpha: 1)
        
        var imgNor = UIImage.loadImage("ic_right_arrow")?.rotate(degree: 180)
        if let img = imgNor {
            imgNor = img.withTintColor(norColor, renderingMode: .alwaysOriginal)
        }
        var imgDis = UIImage.loadImage("ic_right_arrow")?.rotate(degree: 180)
        if let img = imgDis {
            imgDis = img.withTintColor(disColor, renderingMode: .alwaysOriginal)
        }
        button.setImage(imgNor, for: .normal)
        button.setImage(imgDis, for: .disabled)
        button.contentHorizontalAlignment = .right
        button.isHidden = true
        button.isEnabled = false
        //        button.backgroundColor = .yellow
        return button
    }()
    private(set) lazy var mBtnRightArrow: UIButton = {
        let button = UIButton(type: .custom)
        let norColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let disColor = #colorLiteral(red: 0.2470588235, green: 0.2, blue: 0.337254902, alpha: 1)
        let imgNor = UIImage.loadImage("ic_right_arrow")?.withTintColor(norColor, renderingMode: .alwaysOriginal)
        let imgDis = UIImage.loadImage("ic_right_arrow")?.withTintColor(disColor, renderingMode: .alwaysOriginal)
        button.setImage(imgNor, for: .normal)
        button.setImage(imgDis, for: .disabled)
        button.contentHorizontalAlignment = .left
        button.isHidden = true
        button.isEnabled = false
        //        button.backgroundColor = .yellow
        return button
    }()
    
    private(set) lazy var mCollectionContextsView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 45, height: 45)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: CHPhotoEditToolsCell.identify, bundle: .main), forCellWithReuseIdentifier: model.contextsCellIdentity)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private(set) lazy var mCollectionSizeView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 65, height: 90)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: CHPhotoEditToolsCell.identify, bundle: .main), forCellWithReuseIdentifier: model.sizeCellIdentity)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private(set) lazy var mCollectionColorView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 45, height: 45)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: CHPhotoEditToolsCell.identify, bundle: .main), forCellWithReuseIdentifier: model.colorCellIdentity)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private(set) lazy var mCollectionDressView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 45, height: 45)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: CHPhotoEditToolsCell.identify, bundle: .main), forCellWithReuseIdentifier: model.dressCellIdentity)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    private lazy var mMainDressToolsView: UIView = {
        let view = UIView(frame: .zero)
        setupDressUpToolsViewUI(view)
        return view
    }()
    private var dressUPToolsViews: [UIButton] = []
    // 换装的数据列表
    private(set) var dressDataList = ClothingModel.getModelList()
    // 逻辑处理
    private var model: CHPhotoEditToolsLinkedModel!
}

// MARK: - 数据列表处理
extension CHPhotoEditToolsLinkedView: UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.getCellCount(collectionView)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return model.getCell(collectionView, indexPath: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        model.chooseCell(collectionView, indexPath: indexPath)
        collectionView.reloadData()
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return model.getCellSize(collectionView)
    //    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let collection = scrollView as? UICollectionView {
            getScrollEable(view: collection)
        }
    }
}

// MARK: - 私有方法不对外开放
private extension CHPhotoEditToolsLinkedView {
    func setupUI() {
        addSubview(mMainDressToolsView)
        mMainDressToolsView.snp.makeConstraints({
            $0.top.centerX.equalToSuperview()
            $0.height.equalTo(45)
            if let lastBtn = dressUPToolsViews.last {
                $0.right.equalTo(lastBtn.snp.right)
            } else {
                $0.left.right.equalToSuperview()
            }
        })
        // 创建换装切换TitleView 隐藏 只有type 为dress情况显示
        mMainDressToolsView.isHidden = true
        addSubview(mMainStackView)
        mMainStackView.snp.updateConstraints({
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().offset(-30)
            $0.top.equalTo(mMainDressToolsView.snp.bottom).offset(12)
            $0.bottom.equalToSuperview().offset(-10)
            //            $0.height.equalTo(45)
        })
        model = CHPhotoEditToolsLinkedModel(view: self)
        
        mMainStackView.addArrangedSubview(mCollectionSizeView)
        mMainStackView.addArrangedSubview(mCollectionColorView)
        mMainStackView.addArrangedSubview(mCollectionContextsView)
        mMainStackView.addArrangedSubview(mCollectionDressView)
        mCollectionContextsView.snp.makeConstraints({
            $0.height.equalTo(45)
        })
        mCollectionColorView.snp.makeConstraints({
            $0.height.equalTo(45)
        })
        mCollectionSizeView.snp.makeConstraints({
            $0.height.equalTo(90)
        })
        mCollectionDressView.snp.makeConstraints({
            $0.height.equalTo(45)
        })
        allHide()
        
        addSubview(mBtnLeftArrow)
        addSubview(mBtnRightArrow)
        //        mMainStackView.backgroundColor = .red
        mBtnLeftArrow.snp.updateConstraints({
            $0.centerY.equalTo(mMainStackView)
            $0.right.equalTo(mMainStackView.snp.left).offset(-2)
            $0.width.height.equalTo(30)
        })
        mBtnRightArrow.snp.updateConstraints({
            $0.centerY.equalTo(mMainStackView)
            $0.left.equalTo(mMainStackView.snp.right).offset(2)
            $0.width.height.equalTo(mBtnLeftArrow)
        })
    }
    func setupDressUpToolsViewUI(_ rootView: UIView) {
        for (index, item) in dressDataList.enumerated() {
            createButtons(rootView, item: item, index: index)
            if index == 0 {
                dressUPToolsViews[0].isSelected = true
            }
        }
    }
    // 创建换装Tools 切换的Button
    func createButtons(_ rootView: UIView, item: ClothingModel, index: Int) {
        let button = UIButton(type: .custom)
        button.setTitle(item.title, for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.3137254902, green: 0.6, blue: 0.9921568627, alpha: 1), for: .selected)
        button.addTarget(self, action: #selector(selectedButton), for: .touchUpInside)
        button.tag = index
        rootView.addSubview(button)
        button.snp.makeConstraints({
            if dressUPToolsViews.count == 0 {
                $0.left.equalToSuperview().offset(0)
            } else {
                $0.left.equalTo(dressUPToolsViews[dressUPToolsViews.count-1].snp.right).offset(15)
            }
            $0.top.equalToSuperview()
            $0.height.equalTo(35)
        })
        dressUPToolsViews.append(button)
    }
    @objc func selectedButton(_ button: UIButton) {
        for item in dressUPToolsViews {
            item.isSelected = false
        }
        button.isSelected = true
        mDressCurrentIndex = button.tag
        self.mDataList = dressDataList[mDressCurrentIndex].imageNames
        self.mCollectionDressView.reloadData()
    }
    /// 设置当前页面展示类型以及赋值显示的数据
    func setToolsType(_ type: CHPhotoEditType) {
        allHide()
        mMainDressToolsView.isHidden = true
        switch type {
        case .color:
            mCollectionColorView.isHidden = false
            getScrollEable(view: mCollectionColorView)
        case .dress:
            mMainDressToolsView.isHidden = false
            mCollectionDressView.isHidden = false
            getScrollEable(view: mCollectionDressView)
        case .size:
            mCollectionSizeView.isHidden = false
            getScrollEable(view: mCollectionSizeView)
        case .contexts:
            mCollectionContextsView.isHidden = false
            getScrollEable(view: mCollectionContextsView)
        }
        reloadData()
    }
    func allHide() {
        self.mCollectionColorView.isHidden = true
        self.mCollectionSizeView.isHidden = true
        self.mCollectionDressView.isHidden = true
        self.mCollectionContextsView.isHidden = true
    }
    func reloadData() {
        self.mCollectionColorView.reloadData()
        self.mCollectionSizeView.reloadData()
        self.mCollectionDressView.reloadData()
        self.mCollectionContextsView.reloadData()
    }
    func getScrollEable(view collection: UICollectionView) {
        let size = collection.frame.size
        if size.width == 0 || size.height == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: { [weak self] in
                self?.getScrollEable(view: collection)
            })
            return
        }
        let contentSize = collection.contentSize
        if contentSize.width < size.width {
            mBtnLeftArrow.isHidden = true
            mBtnRightArrow.isHidden = true
        } else {
            mBtnLeftArrow.isHidden = false
            mBtnRightArrow.isHidden = false
            //
            mBtnLeftArrow.isEnabled = false
            mBtnRightArrow.isEnabled = false
            if collection.contentOffset.x > 0 {
                mBtnLeftArrow.isEnabled = true
            }
            if (collection.contentOffset.x + size.width) < contentSize.width {
                mBtnRightArrow.isEnabled = true
            }
        }
    }
}

private extension UIImage  {
    func rotated(byDegrees degrees: CGFloat) -> UIImage? {
        let radians = degrees * .pi / 180
        var newSize = CGRect(origin: .zero, size: self.size).applying(CGAffineTransform(rotationAngle: radians)).size
        // Trim off the extremely small float values to avoid core graphics errors
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Move origin to middle
        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        // Rotate around middle
        context.rotate(by: radians)
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    func rotate(degree: CGFloat) -> UIImage? {
        guard let cgImage = cgImage else {
            return nil
        }
        // 将角度转换为相对于 π 的值
        let transformDegree = degree / 180 * .pi
        let rotatedViewBox = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let t = CGAffineTransform(rotationAngle: transformDegree)
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        bitmap?.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        bitmap?.rotate(by: transformDegree)
        bitmap?.scaleBy(x: 1.0, y: -1.0)
        bitmap?.draw(cgImage, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
