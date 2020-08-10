//
//  Session.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 07.08.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import Foundation

class Session {
    
    private let uniqueKey = "appVKClientRSN.userID"
    
    var token: String = ""
    var userID: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: uniqueKey)
        }
        get {
            UserDefaults.standard.integer(forKey: uniqueKey)
        }
    }
    
    static let instance = Session()
    private init(){}
}
