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
    
    private let baseUrl: String = "https://api.vk.com"
    private let apiVersion: String = "5.122"
    
    static let sessionAF: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        let session = Alamofire.Session(configuration: configuration)
        return session
    }()
    
    enum AlbumID: String {
        case wall = "wall"
        case profile = "profile"
        case saved = "saved"
    }
    
    func loadFriendsCodable(token: String, completion: ((Result<[UserItemsCodable], Error>) -> Void)? = nil) {
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token": token,
            "order": "name",
            "fields": ["nickname", "sex", "bdate", "city", "photo_100"],
            "v": apiVersion
        ]
        
        NetworkService.sessionAF.request(baseUrl + path, method: .get, parameters: params).responseData { response in
            guard let data = response.value else { return }
            
            do {
                let friends = try JSONDecoder().decode(UserCodable.self, from: data).response?.items
//                print(friends!)
                completion?(.success(friends!))
            } catch {
                print(error.localizedDescription)
                completion?(.failure(error))
            }
        }.resume()
    }
    
    func loadPhotosCodable(token: String, ownerID: Int, albumID: AlbumID, photoCount: Int, completion: ((Result<[PhotoItemsCodable], Error>) -> Void)? = nil) {
        let path = "/method/photos.get"
        
        let params: Parameters = [
            "access_token": token,
            "owner_id": ownerID,
            "album_id": albumID.rawValue,
            "rev": 1,
            "extended": 1,
            "v": apiVersion
        ]
        
        NetworkService.sessionAF.request(baseUrl + path, method: .get, parameters: params).responseData { response in
            guard let data = response.value else { return }
            
            do {
                let photos = try JSONDecoder().decode(PhotoCodable.self, from: data).response?.items
//                print(photos!)
                completion?(.success(photos!))
            } catch {
                print(error.localizedDescription)
                completion?(.failure(error))
            }
        }.resume()
    }
    
    func loadGroupsCodable(token: String, completion: ((Result<[GroupItemsCodable], Error>) -> Void)? = nil) {
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "v": apiVersion
        ]
        
        NetworkService.sessionAF.request(baseUrl + path, method: .get, parameters: params).responseData { response in
            guard let data = response.value else { return }
            
            do {
                let groups = try JSONDecoder().decode(GroupCodable.self, from: data).response?.items
//                print(groups!)
                completion?(.success(groups!))
            } catch {
                print(error.localizedDescription)
                completion?(.failure(error))
            }
        }.resume()
    }
    
    func loadSearchedGroupsCodable(token: String, searchedGroupName: String, completion: ((Result<[GroupItemsCodable], Error>) -> Void)? = nil) {
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": token,
            "q": searchedGroupName,
            "count": 15,
            "v": apiVersion
        ]
        
        NetworkService.sessionAF.request(baseUrl + path, method: .get, parameters: params).responseData { response in
            guard let data = response.value else { return }
            
            do {
                let groups = try JSONDecoder().decode(GroupCodable.self, from: data).response?.items
//                print(groups!)
                completion?(.success(groups!))
            } catch {
                print(error.localizedDescription)
                completion?(.failure(error))
            }
        }.resume()
    }
 
    /*
    func loadFriends(token: String) {
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token": token,
            "fields": ["nickname", "sex", "bdate", "city"],
            "v": apiVersion
        ]
        
        NetworkService.sessionAF.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            guard let json = response.value else { return }
            print(json)
        }
    }
    
    func loadPhotos(token: String) {
        let path = "/method/photos.get"
        
        let params: Parameters = [
            "access_token": token,
            "album_id": "profile",
            "rev": 1,
            "extended": 1,
            "v": apiVersion
        ]
        
        NetworkService.sessionAF.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            guard let json = response.value else { return }
            print(json)
        }
    }
    
    func loadGroups(token: String) {
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "v": apiVersion
        ]
        
        NetworkService.sessionAF.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            guard let json = response.value else { return }
            print(json)
        }
    }
    
    func loadSearchedGroups(token: String, searchedGroupName: String) {
        let path = "/method/groups.search"
        
        let params: Parameters = [
            "access_token": token,
            "q": searchedGroupName,
            "count": 5,
            "v": apiVersion
        ]
        
        NetworkService.sessionAF.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            guard let data = response.value else { return }
            print(data)
        }
    }
 */
}
