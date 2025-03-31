//
//  CHNavigateView.swift
//  CHPictureEditTools
//
//  Created by DG on 2025/3/27.
//

import UIKit

class CHNavigateView: UIView {
    private(set) var mLabTitle: UILabel!
    private(set) var mBtnBack: UIButton!
    private(set) var mBtnRight: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

private extension CHNavigateView {
    func getButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.isHidden = true
        return btn
    }
    func getLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = .systemFont(ofSize: 15)
        label.isHidden = true
        return label
    }
    func setupUI() {
        mBtnBack = CHConstConfig.default().navButtonBack ?? getButton()
        mBtnRight = CHConstConfig.default().navButtonRight ?? getButton()
        mLabTitle = CHConstConfig.default().navLabelTitle ?? getLabel()
        addSubview(mBtnBack)
        addSubview(mBtnRight)
        addSubview(mLabTitle)
        updateAutoLayot()
        mBtnBack.setContentCompressionResistancePriority(.required, for: .horizontal)
        mBtnRight.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func updateAutoLayot() {
        mBtnBack.snp.remakeConstraints({
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        })
        mBtnRight.snp.remakeConstraints({
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        })
        mLabTitle.snp.remakeConstraints({
            $0.centerY.centerX.equalToSuperview()
            $0.left.greaterThanOrEqualTo(mBtnBack.snp.right).offset(10)
            $0.right.lessThanOrEqualTo(mBtnRight.snp.left).offset(-10)
        })
    }
}
