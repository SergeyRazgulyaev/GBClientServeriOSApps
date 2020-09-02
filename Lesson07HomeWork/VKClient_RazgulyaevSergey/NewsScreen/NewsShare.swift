//
//  NewsShare.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 21.07.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import UIKit

class NewsShare: UIControl {
    
    let newsShareImage = UIImageView()
    var image = UIImage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configure()
    }
    
    func configure() {
        newsShareImage.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        newsShareImage.contentMode = .scaleAspectFit
        addSubview(newsShareImage)
        newsShareImage.image = UIImage(systemName: "arrowshape.turn.up.right")
        newsShareImage.tintColor = .gray
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        addGestureRecognizer(recognizer)
    }
    
    @objc func onTap(_ sender: Any?) {
        print("News share button tapped")
    }
}


