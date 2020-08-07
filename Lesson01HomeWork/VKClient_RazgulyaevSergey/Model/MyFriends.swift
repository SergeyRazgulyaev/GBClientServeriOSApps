//
//  MyFriends.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 10.07.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import UIKit

struct MyFriends {
    let friendName: String
    var friendAvatar: UIImage?
    init(friendName: String, friendAvatar: UIImage?) {
        self.friendName = friendName
        self.friendAvatar = friendAvatar
    }
}

var myFriends: [MyFriends] = [
        MyFriends(friendName: "Alexey Smirnov", friendAvatar: UIImage(named: "photoAlexeySmirnov")),
        MyFriends(friendName: "Arkadiy Popov", friendAvatar: UIImage(named: "photoArkadiyPopov")),
        MyFriends(friendName: "Boris Filippov", friendAvatar: UIImage(named: "photoBorisFilippov")),
        MyFriends(friendName: "Bogdan Zavarzin", friendAvatar: UIImage(named: "photoBogdanZavarzin")),
        MyFriends(friendName: "Mikhail Korovin", friendAvatar: UIImage(named: "photoMikhailKorovin")),
        MyFriends(friendName: "Vasiliy Makarov", friendAvatar: UIImage(named: "photoVasiliyMakarov")),
        MyFriends(friendName: "Zakhar Averin", friendAvatar: UIImage(named: "photoZakharAverin"))
]

var groupedByFirstLetterFriends: [[MyFriends]] = [
    [
        MyFriends(friendName: "Alexey Smirnov", friendAvatar: UIImage(named: "photoAlexeySmirnov")),
        MyFriends(friendName: "Arkadiy Popov", friendAvatar: UIImage(named: "photoArkadiyPopov"))
    ],
    [
        MyFriends(friendName: "Boris Filippov", friendAvatar: UIImage(named: "photoBorisFilippov")),
        MyFriends(friendName: "Bogdan Zavarzin", friendAvatar: UIImage(named: "photoBogdanZavarzin"))
    ],
    [
        MyFriends(friendName: "Mikhail Korovin", friendAvatar: UIImage(named: "photoMikhailKorovin"))
    ],
    [
        MyFriends(friendName: "Vasiliy Makarov", friendAvatar: UIImage(named: "photoVasiliyMakarov"))
    ],
    [
        MyFriends(friendName: "Zakhar Averin", friendAvatar: UIImage(named: "photoZakharAverin"))
    ]
]


