//
//  NewsViewController.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 21.07.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - TableView Customization
extension NewsViewController: UITableViewDataSource {
    
    //MARK: - Number Of Rows In Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsForMe.count
    }
    
    //MARK: - Cell For Row At IndexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as? NewsCell else { fatalError() }
        cell.titleLabel.text = newsForMe[indexPath.row].newsForMeSender
        cell.shortNewsLabel.text = newsForMe[indexPath.row].newsForMeShortText
        cell.newsForMeImage.image = newsForMe[indexPath.row].newsForMeImage
        cell.newsForMeAvatarImage.image = newsForMe[indexPath.row].newsForMeAvatarImage
        return cell
    }
}

//MARK: - Did Select Row At IndexPath
extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print(indexPath)
    }
}
