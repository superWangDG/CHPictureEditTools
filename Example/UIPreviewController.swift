//
//  UIPreviewController.swift
//  Example
//
//  Created by DG on 2025/3/25.
//

import UIKit
import CHPictureEditTools

class UIPreviewController: UIViewController {
    
    var sourceImage: UIImage!
    @IBOutlet weak var mImgOrg: UIImageView!
    @IBOutlet weak var mImgNew: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mImgOrg.image = sourceImage
        setupEditView()
    }
    
    /// 加载编辑的视图
    func setupEditView() {
//        let editView = CHPhotoEditHandleView()
        
        let editView = CHPhotoEditHandleView(rootView: self.view, image: sourceImage, imageName: "test")
        
    }
    
}
