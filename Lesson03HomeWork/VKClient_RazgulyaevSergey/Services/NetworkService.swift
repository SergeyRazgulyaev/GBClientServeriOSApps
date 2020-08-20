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
            guard let json = response.value else { return }
            
            do {
                let friends = try JSONDecoder().decode(UserCodable.self, from: json).response?.items
                print(friends!)
                completion?(.success(friends!))
            } catch {
                print(error.localizedDescription)
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
            guard let json = response.value else { return }
            
            do {
                let photos = try JSONDecoder().decode(PhotoCodable.self, from: json).response?.items
//                print(photos!)
                completion?(.success(photos!))
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func loadGroupsCodable(token: String, completion: ((Result<[UserItemsCodable], Error>) -> Void)? = nil) {
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "v": apiVersion
        ]
        
        NetworkService.sessionAF.request(baseUrl + path, method: .get, parameters: params).responseData { response in
            guard let json = response.value else { return }
            
            do {
                let groups = try JSONDecoder().decode(GroupCodable.self, from: json).response?.items
                print(groups!)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
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
            guard let json = response.value else { return }
            print(json)
        }
    }
    
    
    
    
    
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
}
/*

class NetworkService {

    private let baseUrl: String = "https://api.vk.com"
    private let apiVersion: String = "5.122"
    private var method: Methods?
    
    static let sessionAF: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        let session = Alamofire.Session(configuration: configuration)
        return session
    }()
    
    enum Methods: String {
        case friends = "friends.get"
        case photos = "photos.get"
        case groups = "groups.get"
        case groupsSearch = "groups.search"
    }
    
    enum AlbumID: String {
        case wall = "wall"
        case profile = "profile"
        case saved = "saved"
    }
    
    private func networkRequest(URL: String, method: HTTPMethod, parameters: Parameters, completion: ((Result<[Any], Error>) -> Void)? = nil) {
        NetworkService.sessionAF.request(URL, method: method, parameters: parameters).responseData { response in
            switch response.result {
            case .success(let data):
                switch self.method {
                case .friends:
                    do {
                        let users = try JSONDecoder().decode(UserCodable.self, from: data).response?.items
                        completion?(.success(users!))
                    } catch {
                        print(error.localizedDescription)
                        completion?(.failure(error))
                    }
                case .photos:
                    do {
                        let photos = try JSONDecoder().decode(PhotoCodable.self, from: data).response.items
                        completion?(.success(photos))
                    } catch {
                        print(error.localizedDescription)
                        completion?(.failure(error))
                    }
                case .groups, .groupsSearch:
                    do {
                        let groups = try JSONDecoder().decode(GroupCodable.self, from: data).response?.items
                        completion?(.success(groups!))
                    } catch {
                        print(error.localizedDescription)
                        completion?(.failure(error))
                    }
                case .none:
                    return
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func loadFriendsCodable(token: String, completion: ((Result<[UserItemsCodable], Error>) -> Void)? = nil) {
        method = .friends
        let path = "/method" + method!.rawValue
        
        let params: Parameters = [
            "access_token": token,
            "order": "name",
            "fields": ["nickname", "sex", "bdate", "city"],
            "v": apiVersion
        ]
        
        networkRequest(URL: baseUrl + path, method: .get, parameters: params) { result in
            switch result {
            case let .success(users):
                completion?(.success(users as! [UserItemsCodable]))
            case let .failure(error):
                print(error.localizedDescription)
                completion?(.failure(error))
            }
        }
    }
//
//        NetworkService.sessionAF.request(baseUrl + path, method: .get, parameters: params).responseData { response in
//            guard let json = response.value else { return }
//
//            do {
//                let friends = try JSONDecoder().decode(UserCodable.self, from: json)
////                print(friends)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }.resume()
//    }
    
    func loadPhotosCodable(token: String, ownerID: Int, albumID: AlbumID, photoCount: Int, completion: ((Result<[PhotoItemsCodable], Error>) -> Void)? = nil) {
        method = .photos
        let path = "/method" + method!.rawValue
        
        let params: Parameters = [
            "access_token": token,
            "owner_id": ownerID,
            "album_id": albumID.rawValue,
            "rev": 1,
            "extended": 1,
            "count": photoCount,
            "v": apiVersion
        ]
        networkRequest(URL: baseUrl + path, method: .get, parameters: params) { result in
            switch result {
            case let .success(photos):
                completion?(.success(photos as! [PhotoItemsCodable]))
            case let .failure(error):
                print(error.localizedDescription)
                completion?(.failure(error))
            }
        }
    }
//
//        NetworkService.sessionAF.request(baseUrl + path, method: .get, parameters: params).responseData { response in
//            guard let json = response.value else { return }
//
//
//            do {
//                let photos = try JSONDecoder().decode(PhotoCodable.self, from: json)
////                print(photos)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }.resume()
//    }
    
    func loadGroupsCodable(token: String, completion: ((Result<[GroupItemsCodable], Error>) -> Void)? = nil) {
        method = .groups
        let path = "/method" + method!.rawValue
        
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "v": apiVersion
        ]
        
        networkRequest(URL: baseUrl + path, method: .get, parameters: params) { result in
                switch result {
                case let .success(groups):
                    completion?(.success(groups as! [GroupItemsCodable]))
                case let .failure(error):
                    print(error.localizedDescription)
                    completion?(.failure(error))
                }
            }
        }
    
    func loadSearchedGroupsCodable(token: String, searchedGroupName: String?, completion: ((Result<[GroupItemsCodable], Error>) -> Void)? = nil) {
        method = .groupsSearch
        let path = "/method" + method!.rawValue
        
        let params: Parameters = [
            "access_token": token,
            "q": searchedGroupName ?? "",
            "count": 15,
            "v": apiVersion
        ]
        
        networkRequest(URL: baseUrl + path, method: .get, parameters: params) { result in
            switch result {
            case let .success(groups):
                completion?(.success(groups as! [GroupItemsCodable]))
            case let .failure(error):
                print(error.localizedDescription)
                completion?(.failure(error))
            }
        }
    }
//
//        NetworkService.sessionAF.request(baseUrl + path, method: .get, parameters: params).responseData { response in
//            guard let json = response.value else { return }
//
//            do {
//                let groups = try JSONDecoder().decode(GroupCodable.self, from: json)
////                print(groups)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }.resume()
//    }
    
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
            guard let json = response.value else { return }
            print(json)
        }
    }
    */
}
*/
