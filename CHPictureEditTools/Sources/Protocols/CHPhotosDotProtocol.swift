//
//  CHPhotosDotProtocol.swift
//  CHPictureEditTools
//
//  Created by DG on 2025/3/29.
//  Copyright © 2025 Cloudhearing. All rights reserved.
//
import Combine

protocol CHPhotoDotConfigProvider {
    var dotConfigModel: CHPhotosDotModel { get }
    var dotConfigUpdates: AnyPublisher<CHPhotosDotModel, Never> { get }
}

protocol CHPhotoDotViewModelProtocol: AnyObject {
    var configProvider: CHPhotoDotConfigProvider { get set }
    var config: CHPhotosDotModel { get }
    var totalWidth: CGFloat { get }
    func handleConfigUpdate(_ newConfig: CHPhotosDotModel)
}

