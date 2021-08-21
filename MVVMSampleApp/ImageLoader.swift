//
//  ImageLoader.swift
//  MVVMSampleApp
//
//  Created by Arie Peretz on 21/08/2021.
//

import UIKit
import Combine

class ImageLoader {
    static var shared: ImageLoader = ImageLoader()
    private init() {}
    private var images: [String:UIImage] = [:]
    
    func image(for urlString: String) -> AnyPublisher<UIImage?,Never> {
        // Check if image is cached
        if let image = images[urlString] {
            return Just(image)
                .eraseToAnyPublisher()
        }
        
        // Validate url
        guard let url = URL(string: urlString) else {
            return Just(nil)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .map { UIImage(data: $0) }
            .map { [weak self] uiImage in
                self?.cacheIfNotNil(uiImage: uiImage, forKey: urlString)
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    private func cacheIfNotNil(uiImage: UIImage?, forKey key: String) -> UIImage? {
        if let uiImage = uiImage {
            images.updateValue(uiImage, forKey: key)
        }
        return uiImage
    }
}
