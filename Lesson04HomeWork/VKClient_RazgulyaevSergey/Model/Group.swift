//
//  Group.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 17.08.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import Foundation
import RealmSwift

struct MyGroup {
    let groupName: String
    let groupAvatarURL: String
    let groupID: Int
    
    init(groupName: String, groupAvatarURL: String, groupID: Int) {
        self.groupName = groupName
        self.groupAvatarURL = groupAvatarURL
        self.groupID = groupID
    }
}

class GroupCodable: Decodable {
    let response: GroupResponseCodable?
}

class GroupResponseCodable: Decodable {
    let count: Int = 0
    let items: [GroupItemsCodable]?
}

class GroupItemsCodable: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var photo100: String = ""
    @objc dynamic var screenName: String = ""
    @objc dynamic var type: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photo100 = "photo_100"
        case screenName = "screen_name"
        case type
    }
}

