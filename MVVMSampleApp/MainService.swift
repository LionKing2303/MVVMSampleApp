//
//  MainService.swift
//  MVVMSampleApp
//
//  Created by Arie Peretz on 17/08/2021.
//

import Foundation

protocol Service {
    func fetchData(completionHandler: @escaping (([DataModel])->Void))
}

final class MockService: Service {
    func fetchData(completionHandler: @escaping (([DataModel]) -> Void)) {
        completionHandler(DataModel.mockData)
    }
}

final class MainService: Service {
    func fetchData(completionHandler: @escaping (([DataModel]) -> Void)) {
        guard let url = URL(string: "https://api.github.com/users/LionKing2303/repos") else {
            completionHandler([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let repositories = try decoder.decode([DataModel].self, from: data)
                completionHandler(repositories)
                return
            } catch {
                completionHandler([])
                return
            }
        }
        task.resume()
    }
}
