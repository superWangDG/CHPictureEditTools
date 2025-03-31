//
//  CHAlertView.swift
//  ClickFree
//  自定义弹窗
//  Created by apple on 2024/4/5.
//  Copyright © 2024 CloudHearing. All rights reserved.
//

import UIKit


class CHBaseAlertView : UIView {
    
    enum ShowStyle {
        case text
        case rich
        case input
    }
    
    var onClickBlock:((_ view: CHBaseAlertView, _ isConfirm: Bool, _ reslut: String?) -> Void)?
    
    var isTouchBackDismiss = false
    var isRemoveing = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func onClickBlock(with block:@escaping (_ view: CHBaseAlertView, _ isConfirm: Bool, _ reslut: String?) -> Void ) {
        onClickBlock = block
    }
    func resetError() {
        mLabError.isHidden = true
        mLabError.text = ""
    }
    func showErrorText(_ msg:String) {
        mLabError.isHidden = false
        mLabError.text = msg
    }
    
    init(title:String,des:String? = nil, inputDefault:String? = nil,inputPlaceholder:String? = nil, style:ShowStyle = .text, icon: UIImage? = nil, textAlignment: NSTextAlignment = .center) {
        super.init(frame: .zero)
        
        
        if icon != nil {
            mImgIconView = UIImageView(image: icon!)
        }
        
        setupUI()
        setupAlertContentUI()
        
        mLabTitle.text = title
        mLabContent.text = des ?? ""
        mTextInput.text = inputDefault ?? ""
        mTextInput.placeholder = inputPlaceholder ?? ""
        mLabContent.textAlignment = textAlignment
        switch style {
        case .text, .rich:
            mLabContent.isHidden = false
            mLabContent.attributedText = getAttributedString(content: des ?? "")
        case .input:
            mTextInput.isHidden = false
            //        default:
            //            break
        }
        
        self.isHidden = true
    }
    
    func setupUI() {
        addSubview(mBackgroundView)
        addSubview(mMainContentView)
    }
    
    func setupAlertContentUI() {
        if let iconImage = mImgIconView {
            self.mMainContentView.addSubview(iconImage)
        }
        
        self.mMainContentView.addSubview(mLabTitle)
        self.mMainContentView.addSubview(mContentStackView)
        self.mMainContentView.addSubview(mButtonsStackView)
        self.setupContentLayoutUI()
    }
    
    func showView() {
        self.isHidden = false
        self.mMainContentView.alpha = 1
        self.mBackgroundView.alpha = 0
        self.mMainContentView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        // 执行动画
        UIView.animate(withDuration: 0.25, animations: {
            // 显示的View旋转缩小并移出屏幕
            self.mMainContentView.transform = .identity
            self.mBackgroundView.alpha = 1
        }) { _ in
            
        }
    }
    
    
    func hiddenView() {
        // 执行动画
        UIView.animate(withDuration: 0.25, animations: {
            // 显示的View旋转缩小并移出屏幕
            self.mMainContentView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        }) { _ in
            self.mMainContentView.alpha = 0
            self.mMainContentView.transform = .identity
            UIView.animate(withDuration: 0.25, animations: {
                // 背景View渐变消失
                self.mBackgroundView.alpha = 0.0
            },completion: {
                [weak self]done in
                if self?.isRemoveing == true {
                    self?.removeFromSuperview()
                } else {
                    self?.isHidden = true
                }
            })
        }
    }
    
    private lazy var mBackgroundView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundHideAction)))
        return view
    }()
    
    private(set) lazy var mMainContentView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
    }()
    
    private(set) lazy var mLabTitle:UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    
    //MARK: - Contents 布局不改变的情况下可以将需要的内容容器插入 mContentStackView
    private(set) lazy var mContentStackView:UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        // 富文本 显示
        //        stackView.addArrangedSubview(mRichMainView)
        // 输入框
        stackView.addArrangedSubview(mTextInput)
        //        // 提示内容
        stackView.addArrangedSubview(mLabContent)
        //        // 错误信息
        stackView.addArrangedSubview(mLabError)
        mTextInput.isHidden = true
        //
        mLabContent.isHidden = true
        //
        mLabError.isHidden = true
        
        return stackView
    }()
    
    //MARK: - Error
    private lazy var mLabError:UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.8784313725, green: 0.1254901961, blue: 0.1254901961, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Label
    private(set) lazy var mLabContent:UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    //MARK: - textFiled
    private lazy var mTextInput: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.font = .systemFont(ofSize: 16)
        textField.layer.cornerRadius = 4
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.delegate = self
        textField.returnKeyType = .done
        textField.layer.borderColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1).cgColor
        textField.leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 12, height: 12)))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    //MARK: - rich
    private lazy var mRichMainView: UIView = {
        let view = UIView()
        view.addSubview(mPlaceholder)
        view.addSubview(mTextDes)
        
        mPlaceholder.snp.updateConstraints({
            $0.leading.trailing.top.bottom.equalTo(mLabTitle)
            //            $0.top.greaterThanOrEqualTo(mLabTitle.snp.bottom).offset(10)
            $0.height.lessThanOrEqualTo(150)
        })
        mTextDes.snp.updateConstraints({
            $0.edges.equalTo(mPlaceholder)
        })
        return view
    }()
    
    private lazy var mTextDes:UITextView = {
        let text = UITextView(frame: .zero)
        text.isEditable = false
        text.isScrollEnabled = true
        text.textAlignment = .center
        text.contentInset = .zero
        text.textContainerInset = .zero
        text.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        text.font = .systemFont(ofSize: 14, weight: .regular)
        return text
    }()
    
    private lazy var mPlaceholder:UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    // MARK: - icon
    private(set) var mImgIconView: UIImageView?
    
    //MARK: - buttons
    private lazy var mButtonsStackView:UIStackView = {
        let view = UIStackView(frame: .zero)
        view.spacing = 11
        view.axis = .horizontal
        view.addArrangedSubview(mBtnCancel)
        view.addArrangedSubview(mBtnConfirm)
        view.distribution = .fillEqually
        return view
    }()
    
    lazy var mBtnCancel: UIButton = {
        let btn = createButton()
        btn.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.08235294118, green: 0.537254902, blue: 0.9764705882, alpha: 1), for: .normal)
        return btn
    }()
    
    lazy var mBtnConfirm: UIButton = {
        let btn = createButton()
        btn.setTitle( NSLocalizedString("OK", comment: ""), for: .normal)
        btn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        return btn
    }()
}

extension CHBaseAlertView : UITextFieldDelegate {
    
    @objc func buttonsAction(button:UIButton) {
        mTextInput.resignFirstResponder()
        onClickBlock?(self,button == mBtnConfirm,mTextInput.text)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func backgroundHideAction() {
        if isTouchBackDismiss {
            hiddenView()
        }
    }
    
}

private extension CHBaseAlertView {
    
    func createButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 6
        btn.layer.masksToBounds = true
        btn.layer.borderColor = #colorLiteral(red: 0.08235294118, green: 0.537254902, blue: 0.9764705882, alpha: 1).cgColor
        btn.layer.borderWidth = 1
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.addTarget(self, action: #selector(buttonsAction), for: .touchUpInside)
        return btn
    }
    
    func initView() {
        if let mainWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            // 在这里使用 mainWindow
            mainWindow.rootViewController?.view.addSubview(self)
            self.snp.remakeConstraints({
                $0.edges.equalToSuperview()
            })
        }
    }
    
    func setupContentLayoutUI() {
        self.snp.remakeConstraints({
            $0.edges.equalToSuperview()
        })
        mBackgroundView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        mMainContentView.snp.remakeConstraints({
            $0.center.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(30)
            $0.trailing.greaterThanOrEqualToSuperview().offset(-30)
        })
        
        self.mImgIconView?.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(30)
        })
        mLabTitle.snp.updateConstraints({
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            if self.mImgIconView == nil {
                $0.top.equalToSuperview().offset(20)
            } else {
                $0.top.equalTo(mImgIconView!.snp.bottom).offset(20)
            }
        })
        mContentStackView.snp.updateConstraints({
            $0.leading.trailing.equalTo(mLabTitle)
            $0.top.equalTo(mLabTitle.snp.bottom).offset(40)
            
        })
        mButtonsStackView.snp.updateConstraints({
            $0.leading.trailing.equalTo(mLabTitle)
            $0.top.equalTo(mContentStackView.snp.bottom).offset(30)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().offset(-24)
        })
        mTextInput.snp.remakeConstraints({
            $0.height.equalTo(40)
        })
    }
    func getAttributedString(content: String) -> NSAttributedString {
        // 创建可变富文本字符串
        let attributedString = NSMutableAttributedString(string: content)
        // 使用正则表达式找到 <b> 标签的内容
        let regexPattern = "<b>(.*?)</b>"
        let regex = try! NSRegularExpression(pattern: regexPattern, options: [])
        let nsString = content as NSString
        let results = regex.matches(in: content, options: [], range: NSRange(location: 0, length: nsString.length))
        // 遍历找到的结果，并将内容加粗
        for result in results {
            let range = result.range(at: 1) // 获取 <b> 标签内的文本范围
            let boldFont = UIFont.systemFont(ofSize: 12, weight: .bold) // 设置加粗字体大小
            // 设置加粗属性
            attributedString.addAttribute(.font, value: boldFont, range: range)
            // 去掉 <b> 和 </b> 标签
            attributedString.mutableString.replaceCharacters(in: NSRange(location: result.range.location, length: 3), with: "")
            attributedString.mutableString.replaceCharacters(in: NSRange(location: result.range.location + range.length, length: 4), with: "")
        }
        return attributedString
    }
    
}
