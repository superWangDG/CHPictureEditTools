//
//  CHPhotoLoadingProtocol.swift
//  CHPictureEditTools
//
//  Created by DG on 2025/3/31.
//  Copyright © 2025 Cloudhearing. All rights reserved.
//

import Combine

protocol CHPhotoLoadingProvider {
    var loadingConfigModel: CHPhotoLoadingModel { get }
    var loadingConfigUpdates: AnyPublisher<CHPhotoLoadingModel, Never> { get }
}

protocol CHPhotoLoadingViewModelProtocol: AnyObject {
    var provider: CHPhotoLoadingProvider { get set }
    var config: CHPhotoLoadingModel { get }
    func handleConfigUpdate(_ newConfig: CHPhotoLoadingModel)
}

