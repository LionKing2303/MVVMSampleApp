//
//  MainService.swift
//  MVVMSampleApp
//
//  Created by Arie Peretz on 17/08/2021.
//

import Foundation
import Combine

enum ServiceError: Error {
    case invalidURL
    case general
}

protocol Service {
    func fetchData() -> AnyPublisher<[DataModel],ServiceError>
}

final class MockService: Service {
    func fetchData() -> AnyPublisher<[DataModel], ServiceError> {
        Just(DataModel.mockData)
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
}

final class MainService: Service {
    func fetchData() -> AnyPublisher<[DataModel], ServiceError> {
        guard let url = URL(string: "https://api.github.com/users/LionKing2303/repos") else {
            return Fail(error: ServiceError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [DataModel].self, decoder: decoder)
            .mapError { _ in ServiceError.general }
            .eraseToAnyPublisher()
    }
}
