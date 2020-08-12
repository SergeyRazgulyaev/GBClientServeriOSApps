//
//  NetworkService.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 12.08.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService {
    
    static let sessionAF: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        let session = Alamofire.Session(configuration: configuration)
        return session
    }()
    
    static func loadFriends(token: String) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token": token,
            "fields": ["nickname", "sex", "bdate", "city"],
            "v": "5.92"
        ]
        
        NetworkService.sessionAF.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            guard let json = response.value else { return }
            print(json)
        }
    }
    
    static func loadPhotos(token: String) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/photos.get"
        
        let params: Parameters = [
            "access_token": token,
            "album_id": "profile",
            "rev": 1,
            "extended": 1,
            "v": "5.92"
        ]
        
        NetworkService.sessionAF.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            guard let json = response.value else { return }
            print(json)
        }
    }
    
    static func loadGroups(token: String) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/groups.get"

        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "v": "5.92"
        ]
        
        NetworkService.sessionAF.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            guard let json = response.value else { return }
            print(json)
        }
    }
    
    static func loadSearchedGroups(token: String) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/groups.search"

        let params: Parameters = [
            "access_token": token,
            "q": "drive",
            "count": 5,
            "v": "5.92"
        ]
        
        NetworkService.sessionAF.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            guard let json = response.value else { return }
            print(json)
        }
    }
}
