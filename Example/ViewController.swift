//
//  ViewController.swift
//  Example
//
//  Created by DG on 2025/3/25.
//

import UIKit
import ZLPhotoBrowser

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func openAblumAction(_ sender: Any) {
        let sheet = ZLPhotoPreviewSheet()
        sheet.selectImageBlock = { list, isFull in
            guard let img = list.first?.image else { return }
            self.performSegue(withIdentifier: "Segue_PreviewController", sender: img)
        }
        sheet.showPhotoLibrary(sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue_PreviewController",
           let vc = segue.destination as? UIPreviewController,
           let img = sender as? UIImage
        {
            vc.sourceImage = img
        }
    }
    
}

