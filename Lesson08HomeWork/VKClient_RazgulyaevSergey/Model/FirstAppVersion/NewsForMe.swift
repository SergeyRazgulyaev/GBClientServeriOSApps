//
//  NewsForMe.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 21.07.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import UIKit

struct NewsForMe {
    let newsForMeSender: String
    let newsForMeShortText: String
    var newsForMeImage: UIImage?
    var newsForMeAvatarImage: UIImage?
    init(newsForMeSender: String, newsForMeShortText: String, newsForMeImage: UIImage?, newsForMeAvatarImage: UIImage?) {
        self.newsForMeSender = newsForMeSender
        self.newsForMeShortText = newsForMeShortText
        self.newsForMeImage = newsForMeImage
        self.newsForMeAvatarImage = newsForMeAvatarImage
    }
}

var newsForMe: [NewsForMe] = [
    NewsForMe(newsForMeSender: "Kinopoisk.ru", newsForMeShortText: "Turtles attack in the cinema. Nickelodeon teamed up with production company Point Gray Pictures under the leadership of Seth Rogen to reboot the MCU Teenage Mutant Ninja Turtles", newsForMeImage: UIImage(named: "TMNT"), newsForMeAvatarImage: UIImage(named: "kinopoisk")),
    NewsForMe(newsForMeSender: "IOS Dev", newsForMeShortText: "Apple is officially switching to native chips for some Macs. Calling it a historic day for the Mac, Apple CEO Tim Cook detailed the move to PowerPC, OS X 10 and the move to Intel chips, and then unveiled plans to use Apple's own ARM chip in the Mac in the future", newsForMeImage: UIImage(named: "appleProcessor"), newsForMeAvatarImage: UIImage(named: "iOSDev")),
    NewsForMe(newsForMeSender: "Oil and Gas", newsForMeShortText: "Falling oil prices. From October 3 to November 29, oil quotations fell by more than a third - from $ 86.74 to $ 57.78 per barrel of Brent. Such sharp price reductions were observed only at the end of 2008 and in the fall of 2014", newsForMeImage: UIImage(named: "oilPriceFalling"), newsForMeAvatarImage: UIImage(named: "oilAndGas"))
]
