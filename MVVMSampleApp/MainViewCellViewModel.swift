//
//  MainViewCellViewModel.swift
//  MVVMSampleApp
//
//  Created by Arie Peretz on 21/08/2021.
//

import UIKit
import Combine

extension MainViewCell {
    final class ViewModel: ObservableObject {
        let item: MainTableViewCellModel
        @Published var image: UIImage?
        private var downloadTask: AnyCancellable?
        
        init(item: MainTableViewCellModel) {
            self.item = item
            fetchAvatar()
        }
        
        func fetchAvatar() {
            downloadTask = ImageLoader.shared.image(for: item.avatarURL)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] uiImage in
                    self?.image = uiImage
                }
        }
    }
}
