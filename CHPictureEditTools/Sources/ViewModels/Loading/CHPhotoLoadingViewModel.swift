//
//  CHPhotoLoadingViewModel.swift
//  CHPictureEditTools
//
//  Created by DG on 2025/3/29.
//  Copyright © 2025 Cloudhearing. All rights reserved.
//

import Foundation
import Combine


public class CHPhotoLoadingViewModel: CHPhotoLoadingViewModelProtocol {
    var provider: CHPhotoLoadingProvider {
        didSet {
            bindConfigUpdates()
        }
    }
    @Published private(set) var isLoading = false
    @Published private(set) var config: CHPhotoLoadingModel
    private var cancellabels = Set<AnyCancellable>()
    var animationDuration: TimeInterval {
        get { config.animationDuration }
    }
    
    init(provider: CHPhotoLoadingProvider = CHConstConfig.default()) {
        self.provider = provider
        self.config = provider.loadingConfigModel
    }
    private func bindConfigUpdates() {
        provider.loadingConfigUpdates
            .receive(on: DispatchQueue.main)
            .sink { [weak self]model in
                self?.handleConfigUpdate(model)
            }
            .store(in: &cancellabels)
    }
    func handleConfigUpdate(_ newConfig: CHPhotoLoadingModel) {
        self.config = newConfig
    }
    
    func showLoading(show: Bool = true) {
        isLoading = show
    }
}
