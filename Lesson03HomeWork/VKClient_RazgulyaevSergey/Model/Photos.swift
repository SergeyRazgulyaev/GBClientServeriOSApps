//
//  Photos.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 17.08.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import UIKit

struct PhotoData {
    let photoNumber: Int
    let photoCardURL: String
    init(photoNumber: Int, photoCardURL: String) {
        self.photoNumber = photoNumber
        self.photoCardURL = photoCardURL
    }
}

struct PhotoCodable: Codable {
    let response: PhotoResponseCodable?
}

struct PhotoResponseCodable: Codable {
    let count: Int?
    let items: [PhotoItemsCodable]?
}

struct PhotoItemsCodable: Codable {
    let albumID: Int?
    let canComment: Int?
    let comments: CommentsCodable?
    let date: Int?
    let id: Int?
    let likes: LikesCodable?
    let ownerID: Int?
    let postID: Int?
    let reposts: RepostCodable?
    let sizes: [SizesCodable]?
    let tags: TagsCodable?
    let text: String?
    
    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case canComment = "can_comment"
        case comments
        case date
        case id
        case likes
        case ownerID = "owner_id"
        case postID = "post_id"
        case reposts
        case sizes
        case tags
        case text
    }
}

struct CommentsCodable: Codable {
    let count: Int?
}

struct LikesCodable: Codable {
    let count: Int?
    let userLikes: Int?
    
    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
    }
}

struct RepostCodable: Codable {
    let count: Int?
}

struct SizesCodable: Codable {
    let height: Int?
    let type: String?
    let url: String?
    let width: Int?
}

struct TagsCodable: Codable {
    let count: Int?
}
