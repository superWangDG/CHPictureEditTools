//
//  CHPhotosDotViewModel.swift
//  CHPictureEditTools
//
//  Created by DG on 2025/3/27.
//

import Combine

class CHPhotosDotViewModel: CHPhotoDotViewModelProtocol {
    var configProvider: CHPhotoDotConfigProvider {
        didSet {
            bindConfigUpdates()
        }
    }
    @Published private(set) var config: CHPhotosDotModel
    @Published var isAnimating: Bool = false
    private var cancellables = Set<AnyCancellable>()
    init(configProvider: CHPhotoDotConfigProvider = CHConstConfig.default()) {
        self.configProvider = configProvider
        self.config = configProvider.dotConfigModel
    }
    /// 计算当前的点宽度
    var totalWidth: CGFloat {
        let totalSpacing = CGFloat(config.numberOfDots - 1) * config.spacing
        return CGFloat(config.numberOfDots) * config.size + totalSpacing
    }
    func startAnimation() {
        isAnimating = true
    }
    func stopAnimation() {
        isAnimating = false
    }
    func handleConfigUpdate(_ newConfig: CHPhotosDotModel) {
        config = newConfig
    }
}

private extension CHPhotosDotViewModel {
    func bindConfigUpdates() {
        configProvider.dotConfigUpdates
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self]model in
                self?.handleConfigUpdate(model)
            })
            .store(in: &cancellables)
    }
}


