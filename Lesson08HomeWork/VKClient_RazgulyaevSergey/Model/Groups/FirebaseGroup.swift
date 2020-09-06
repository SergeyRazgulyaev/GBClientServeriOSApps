//
//  FirebaseGroup.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 06.09.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseGroup {
    
    let id: Int
    let name: String
    let photo100: String
    let screenName: String
    let type: String
    
    let ref: DatabaseReference?
    
    init(id: Int, name: String, photo100: String, screenName: String, type: String) {
        self.id = id
        self.name = name
        self.photo100 = photo100
        self.screenName = screenName
        self.type = type
        self.ref = nil
    }
    
    convenience init(from groupModel: GroupItems) {
        let id = groupModel.id
        let name = groupModel.name
        let photo100 = groupModel.photo100
        let screenName = groupModel.screenName
        let type = groupModel.type
        
        self.init(id: id, name: name, photo100: photo100, screenName: screenName, type: type)
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return nil }
        guard let id = value["id"] as? Int,
        let name = value["name"] as? String,
        let photo100 = value["photo100"] as? String,
        let screenName = value["screenName"] as? String,
        let type = value["type"] as? String else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.id = id
        self.name = name
        self.photo100 = photo100
        self.screenName = screenName
        self.type = type
    }
    
    init?(dict: [String: Any]) {
        guard let id = dict["id"] as? Int,
            let name = dict["name"] as? String,
            let photo100 = dict["photo100"] as? String,
            let screenName = dict["screenName"] as? String,
            let type = dict["type"] as? String else { return nil }
        
        self.id = id
        self.name = name
        self.photo100 = photo100
        self.screenName = screenName
        self.type = type
        self.ref = nil
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "photo100": photo100,
            "screenName": screenName,
            "type": type
        ]
    }
}
