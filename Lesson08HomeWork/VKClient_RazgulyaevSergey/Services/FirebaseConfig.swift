//
//  FirebaseConfig.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 06.09.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import Foundation

enum DatabaseType {
    
    case database
    case firestore
}

enum Config {
    
    static let databaseType: DatabaseType = .database
}
