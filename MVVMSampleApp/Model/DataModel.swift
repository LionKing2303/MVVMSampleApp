//
//  DataModel.swift
//  MVVMSampleApp
//
//  Created by Arie Peretz on 17/08/2021.
//

import Foundation

struct DataModel: Codable {
    let id: Double
    let name: String?
    let fullName: String?
    let owner: Owner?
    let language: String?
    let defaultBranch: String?
    let createdAt: Date?
    let cloneURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case fullName = "full_name"
        case owner = "owner"
        case language = "language"
        case defaultBranch = "default_branch"
        case createdAt = "created_at"
        case cloneURL = "clone_url"
    }
    
    var toCellModel: MainTableViewCellModel {
        MainTableViewCellModel(
            avatarURL: self.owner?.avatarUrl ?? "",
            repositoryName: self.name ?? "No name",
            defaultBranchName: self.defaultBranch ?? "None",
            language: self.language ?? "None"
        )
    }
}

extension DataModel {
    struct Owner: Codable {
        let avatarUrl: String
        
        enum CodingKeys: String, CodingKey {
            case avatarUrl = "avatar_url"
        }
    }
}

extension DataModel {
    static let mockData: [Self] = [
        DataModel(
            id: 1,
            name: "First repo",
            fullName: "First Repository",
            owner: DataModel.Owner(
                avatarUrl: "https://avatars.githubusercontent.com/u/26278101?v=4"
            ),
            language: "Swift",
            defaultBranch: "main",
            createdAt: Date(),
            cloneURL: "https://github.com/LionKing2303/FirstRepo.git"
        ),
        DataModel(
            id: 2,
            name: "Second repo",
            fullName: "Second Repository",
            owner: DataModel.Owner(
                avatarUrl: "https://avatars.githubusercontent.com/u/26278101?v=4"
            ),
            language: "Swift",
            defaultBranch: "main",
            createdAt: Date(),
            cloneURL: "https://github.com/LionKing2303/FirstRepo.git"),
        DataModel(
            id: 3,
            name: "Third repo",
            fullName: "Third Repository",
            owner: DataModel.Owner(
                avatarUrl: "https://avatars.githubusercontent.com/u/26278101?v=4"
            ),
            language: "Java",
            defaultBranch: "master",
            createdAt: Date(),
            cloneURL: "https://github.com/LionKing2303/FirstRepo.git"
        )
    ]
}
