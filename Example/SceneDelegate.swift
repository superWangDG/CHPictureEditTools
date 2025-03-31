//
//  SceneDelegate.swift
//  Example
//
//  Created by DG on 2025/3/25.
//

import UIKit
import ZLPhotoBrowser

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        setupBrowserConfig()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func setupBrowserConfig() {
        ZLPhotoConfiguration.default().allowSelectVideo = false
        ZLPhotoConfiguration.default().allowSelectGif = false
        ZLPhotoConfiguration.default().allowEditImage = false
        ZLPhotoConfiguration.default().allowEditVideo = false
        ZLPhotoConfiguration.default().allowTakePhotoInLibrary = false
        
//        mCollectionView.contentInset
        // 排序 最新的在上面
        ZLPhotoUIConfiguration.default().sortAscending = false
        ZLPhotoUIConfiguration.default().minimumInteritemSpacing = 8
        ZLPhotoUIConfiguration.default().minimumLineSpacing = 8
        ZLPhotoUIConfiguration.default().bottomToolViewBgColorOfPreviewVC = .clear
        // 完成按钮颜色
        ZLPhotoUIConfiguration.default().bottomToolViewBtnNormalBgColorOfPreviewVC = #colorLiteral(red: 0, green: 0.6466644406, blue: 1, alpha: 1)
        // 弹出的图片选择背景
        ZLPhotoUIConfiguration.default().albumListBgColor = #colorLiteral(red: 0.9450980392, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
        // 列表文字颜色
        ZLPhotoUIConfiguration.default().albumListTitleColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        ZLPhotoUIConfiguration.default().albumListCountColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        
        ZLPhotoUIConfiguration.default().navBarColor = #colorLiteral(red: 0.9450980392, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
        ZLPhotoUIConfiguration.default().navCancelButtonStyle = .text
        ZLPhotoUIConfiguration.default().navTitleColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        ZLPhotoUIConfiguration.default().navViewBlurEffectOfAlbumList = nil
        ZLPhotoUIConfiguration.default().navTitleColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        ZLPhotoUIConfiguration.default().thumbnailBgColor = #colorLiteral(red: 0.9450980392, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
        ZLPhotoUIConfiguration.default().navEmbedTitleViewBgColor = .clear
    }
}

