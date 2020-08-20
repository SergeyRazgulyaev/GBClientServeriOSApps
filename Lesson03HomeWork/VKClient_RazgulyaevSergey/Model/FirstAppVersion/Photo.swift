//
//  Photo.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 09.07.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import UIKit

struct PhotosData {
    let photoHolder: String
    let photoNumber: Int
    let photoDate: String
    let photoCard: UIImage?
    init(photoHolder: String, photoNumber: Int, photoDate: String, photoCard: UIImage?) {
        self.photoHolder = photoHolder
        self.photoNumber = photoNumber
        self.photoDate = photoDate
        self.photoCard = photoCard
    }
}

//var photos = [
//        PhotosData(photoHolder: "Alexey Smirnov", photoNumber: 4, photoDate: "14.10.2019", photoCard: UIImage(named: "ph004")),
//        PhotosData(photoHolder: "Alexey Smirnov", photoNumber: 3, photoDate: "25.09.2019", photoCard: UIImage(named: "ph003")),
//        PhotosData(photoHolder: "Alexey Smirnov", photoNumber: 2, photoDate: "05.08.2019", photoCard: UIImage(named: "ph002")),
//        PhotosData(photoHolder: "Alexey Smirnov", photoNumber: 1, photoDate: "15.07.2019", photoCard: UIImage(named: "ph001")),
//        
//        PhotosData(photoHolder: "Arkadiy Popov", photoNumber: 3, photoDate: "12.09.2019", photoCard: UIImage(named: "ph007")),
//        PhotosData(photoHolder: "Arkadiy Popov", photoNumber: 2, photoDate: "04.08.2019", photoCard: UIImage(named: "ph006")),
//        PhotosData(photoHolder: "Arkadiy Popov", photoNumber: 1, photoDate: "30.07.2019", photoCard: UIImage(named: "ph005")),
//        
//        PhotosData(photoHolder: "Boris Filippov", photoNumber: 2, photoDate: "21.06.2019", photoCard: UIImage(named: "ph006")),
//        PhotosData(photoHolder: "Boris Filippov", photoNumber: 1, photoDate: "11.05.2019", photoCard: UIImage(named: "ph005")),
//
//        PhotosData(photoHolder: "Bogdan Zavarzin", photoNumber: 2, photoDate: "12.05.2019", photoCard: UIImage(named: "ph007")),
//        PhotosData(photoHolder: "Bogdan Zavarzin", photoNumber: 1, photoDate: "02.03.2019", photoCard: UIImage(named: "ph003")),
//
//        PhotosData(photoHolder: "Mikhail Korovin", photoNumber: 2, photoDate: "08.04.2019", photoCard: UIImage(named: "ph005")),
//        PhotosData(photoHolder: "Mikhail Korovin", photoNumber: 1, photoDate: "12.02.2019", photoCard: UIImage(named: "ph001")),
//
//        PhotosData(photoHolder: "Vasiliy Makarov", photoNumber: 2, photoDate: "04.03.2019", photoCard: UIImage(named: "ph006")),
//        PhotosData(photoHolder: "Vasiliy Makarov", photoNumber: 1, photoDate: "30.01.2019", photoCard: UIImage(named: "ph004")),
//
//        PhotosData(photoHolder: "Zakhar Averin", photoNumber: 2, photoDate: "01.02.2019", photoCard: UIImage(named: "ph003")),
//        PhotosData(photoHolder: "Zakhar Averin", photoNumber: 1, photoDate: "15.01.2019", photoCard: UIImage(named: "ph002")),
//        
//        PhotosData(photoHolder: "Tortoise", photoNumber: 1, photoDate: "01.01.2020", photoCard: UIImage(systemName: "tortoise"))
//]
