//
//  Photos.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 17.08.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import UIKit
import RealmSwift

struct PhotoData {
    let photoNumber: Int
    let photoCardURL: String
    init(photoNumber: Int, photoCardURL: String) {
        self.photoNumber = photoNumber
        self.photoCardURL = photoCardURL
    }
}

class PhotoCodable: Decodable {
    let response: PhotoResponseCodable?
}

class PhotoResponseCodable: Decodable {
    let count: Int = 0
    let items: [PhotoItemsCodable]?
}

class PhotoItemsCodable: Object, Decodable {
    @objc dynamic var albumID: Int = 0
    @objc dynamic var date: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var likes: LikesCodable?
    @objc dynamic var ownerID: Int = 0
    var sizes = List<SizesCodable>()
    
    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date
        case id
        case likes
        case ownerID = "owner_id"
        case sizes
    }
}

class LikesCodable: Object, Decodable {
    @objc dynamic var count: Int = 0
    @objc dynamic var userLikes: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
    }
}

class SizesCodable: Object, Decodable {
    @objc dynamic var height: Int = 0
    @objc dynamic var type: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var width: Int = 0
}
//
//extension List: Decodable where Element: Decodable {
//    public convenience init(from decoder: Decoder) throws {
//        self.init()
//        var container = try decoder.unkeyedContainer()
//        while !container.isAtEnd {
//            let element = try container.decode(Element.self)
//            self.append(element)
//        }
//    }
//}
