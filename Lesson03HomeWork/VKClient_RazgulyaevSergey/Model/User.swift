//
//  User.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 17.08.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import UIKit

struct MyFriends {
    let friendName: String
    var friendAvatarURL: String
    let friendID: Int
    
    init(friendName: String, friendAvatarURL: String, friendID: Int) {
        self.friendName = friendName
        self.friendAvatarURL = friendAvatarURL
        self.friendID = friendID
    }
}

struct UserCodable: Codable {
    let response: UserResponseCodable?
}

struct UserResponseCodable: Codable {
    let count: Int?
    let items: [UserItemsCodable]?
}

struct UserItemsCodable: Codable {
    let city: UserCityCodable?
    let firstName: String?
    let id: Int?
    let lastName: String?
    let nickname: String?
    let online: Int?
    let sex: Int?
    let photo100: String?
    
    enum CodingKeys: String, CodingKey {
        case city
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case nickname
        case online
        case sex
        case photo100 = "photo_100"
    }
}

struct UserCityCodable: Codable {
    let id: Int?
    let title: String?
}
