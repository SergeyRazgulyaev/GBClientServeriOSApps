//
//  User.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 17.08.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import UIKit
import RealmSwift

struct MyFriends {
    let friendName: String
    let friendAvatarURL: String
    let friendID: Int
    
    init(friendName: String, friendAvatarURL: String, friendID: Int) {
        self.friendName = friendName
        self.friendAvatarURL = friendAvatarURL
        self.friendID = friendID
    }
}

class UserCodable: Decodable {
    var response: UserResponseCodable?
}

class UserResponseCodable: Decodable {
    var count: Int = 0
    var items: [UserItemsCodable]?
}

class UserItemsCodable: Object, Decodable {
    @objc dynamic var city: UserCityCodable?
    @objc dynamic var firstName: String = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var lastName: String = ""
    @objc dynamic var online: Int = 0
    @objc dynamic var sex: Int = 0
    @objc dynamic var photo100: String = ""
    
    enum CodingKeys: String, CodingKey {
        case city
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case online
        case sex
        case photo100 = "photo_100"
    }
}

class UserCityCodable: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
}
