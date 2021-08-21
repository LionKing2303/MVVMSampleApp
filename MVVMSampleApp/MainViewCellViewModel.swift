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
            guard let url = URL(string: item.avatarURL) else { return }
            downloadTask = URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .map { UIImage(data: $0) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] uiImage in
                    self?.image = uiImage
                }
        }
    }
}
