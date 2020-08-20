//
//  Group.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 17.08.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import Foundation

struct GroupCodable: Codable {
    let response: GroupResponseCodable?
}

struct GroupResponseCodable: Codable {
    let count: Int?
    let items: [GroupItemsCodable]?
}

struct GroupItemsCodable: Codable {
    let id: Int?
    let isAdmin: Int?
    let isAdvertiser: Int?
    let isClosed: Int?
    let isMember: Int?
    let name: String?
    let photo100: String?
    let screenName: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case isAdmin = "is_admin"
        case isAdvertiser = "is_advertiser"
        case isClosed = "is_closed"
        case isMember = "is_member"
        case name
        case photo100 = "photo_100"
        case screenName = "screen_name"
        case type
    }
}

