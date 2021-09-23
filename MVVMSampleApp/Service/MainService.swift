//
//  MainService.swift
//  MVVMSampleApp
//
//  Created by Arie Peretz on 17/08/2021.
//

import Foundation

enum ServiceError: Error {
    case invalidURL
    case general
}

protocol Service {
    func fetchData(completionHandler: @escaping (Result<[DataModel],ServiceError>) -> Void)
}

final class MockService: Service {
    func fetchData(completionHandler: @escaping (Result<[DataModel],ServiceError>) -> Void) {
        completionHandler(.success(DataModel.mockData))
    }
}

final class MainService: Service {
    func fetchData(completionHandler: @escaping (Result<[DataModel],ServiceError>) -> Void) {
        guard let url = URL(string: "https://api.github.com/users/LionKing2303/repos") else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(.failure(.general))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let repositories = try decoder.decode([DataModel].self, from: data)
                completionHandler(.success(repositories))
                return
            } catch {
                completionHandler(.failure(.general))
                return
            }
        }
        task.resume()
    }
}
