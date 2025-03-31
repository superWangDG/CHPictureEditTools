//
//  CHConstConfig.swift
//  CHPictureEditTools
//  一些常量的配置
//  Created by DG on 2025/3/26.
//
import UIKit
import Combine

public class CHConstConfig: NSObject {
    public class func `default`() -> CHConstConfig { CHConstConfig.single }
    private static var single = CHConstConfig()
    private(set) lazy var resouceBundle: Bundle = { getSysBundle() }()
    private let dotConfigSubject = CurrentValueSubject<CHPhotosDotModel, Never>(.default)
    private let loadingConfigSubject = CurrentValueSubject<CHPhotoLoadingModel, Never>(.default)
    
    var navButtonBack: UIButton?
    var navButtonRight: UIButton?
    var navLabelTitle: UILabel?
    
    func updateDotConfig(_ builder: (inout CHPhotosDotModel.Builder) -> Void) {
        _updateDotConfig(builder)
    }
    func updateLoadingConfig(_ builder: (inout CHPhotoLoadingModel.Builder) -> Void) {
        _updateLoadingConfig(builder)
    }
    
}

// MARK: Dot Model
extension CHConstConfig: CHPhotoDotConfigProvider {
    var dotConfigModel: CHPhotosDotModel {
        dotConfigSubject.value
    }
    var dotConfigUpdates: AnyPublisher<CHPhotosDotModel, Never> {
        dotConfigSubject.eraseToAnyPublisher()
    }
}

// MARK: Loading Model
extension CHConstConfig: CHPhotoLoadingProvider {
    var loadingConfigModel: CHPhotoLoadingModel {
        loadingConfigSubject.value
    }
    var loadingConfigUpdates: AnyPublisher<CHPhotoLoadingModel, Never> {
        loadingConfigSubject.eraseToAnyPublisher()
    }
}

private extension CHConstConfig {
    func getSysBundle() -> Bundle {
        guard let bundleUrl = Bundle(for: CHPhotoEditHandleView.self).url(forResource: "CHPictureEditToolsResource", withExtension: "bundle"),
              let bundle = Bundle(url: bundleUrl) else {
            print("Bundle not found")
            return .main
        }
        return bundle
    }
    
    func _updateDotConfig(_ builder: (inout CHPhotosDotModel.Builder) -> Void) {
        var configBuilder = CHPhotosDotModel.Builder()
        builder(&configBuilder)
        dotConfigSubject.send(configBuilder.build())
    }
    
    func _updateLoadingConfig(_ builder: (inout CHPhotoLoadingModel.Builder) -> Void) {
        var configBuilder = CHPhotoLoadingModel.Builder()
        builder(&configBuilder)
        loadingConfigSubject.send(configBuilder.build())
    }
}

