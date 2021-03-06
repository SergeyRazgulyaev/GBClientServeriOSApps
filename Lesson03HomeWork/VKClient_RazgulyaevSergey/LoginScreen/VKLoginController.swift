//
//  VKLoginController.swift
//  NetworkService
//
//  Created by Evgenii Semenov on 09.08.2020.
//  Copyright © 2020 Evgenii Semenov. All rights reserved.
//

import UIKit
import WebKit

class VKLoginController: UIViewController {
    
    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        removeCookies()
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "7572518"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.92")
        ]
        
        let request = URLRequest(url: components.url!)
        webView.load(request)
    }
}
//func removeCookies(){
//    let cookieJar = HTTPCookieStorage.shared
//    for cookie in cookieJar.cookies! {
//        cookieJar.deleteCookie(cookie)
//    }
//}

extension VKLoginController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else { decisionHandler(.allow); return }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        print(params)
        
        guard let token = params["access_token"],
            let userIdString = params["user_id"],
            let _ = Int(userIdString) else {
                decisionHandler(.allow)
                return
        }
        
        Session.instance.token = token
        performSegue(withIdentifier: "loginSegueNetwork", sender: nil)
        
//        NetworkService.loadFriends(token: token)
//        networkService.loadFriendsCodable(token: token)
        
//        NetworkService.loadPhotos(token: token)
//        networkService.loadPhotosCodable(token: token, ownerID: 158156, albumID: .profile, photoCount: 10)
        
//        NetworkService.loadGroups(token: token)
//        networkService.loadGroupsCodable(token: token)
        
//        NetworkService.loadSearchedGroups(token: token, searchedGroupName: "drive")
        
        decisionHandler(.cancel)
    }
}

