//
//  FriendsViewController.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 09.07.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let networkService = NetworkService()
    var friendsNamesFromNetwork: [String] = []
    var friendsIDFromNetwork: [Int] = []
    var avatarURLFromNetwork: [String] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var filteredFriends = [MyFriends]()
    private var groupedByFirstLetterFriendsName: [[String]] = []
    private var groupedByFirstLetterFriendsURL: [[String]] = []
    private var groupedByFirstLetterFriendsID: [[Int]] = []
    var myFriends: [MyFriends] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFriendsFromNetWork()
        tableView.dataSource = self
        tableView.delegate = self
        
        let view = UIView()
        view.frame = .init(x: 0, y: 0, width: 0, height: 30)
        tableView.tableHeaderView = view
        
        tableView.register(UINib(nibName: "SectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerFirstLetter")
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search My Friends"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "photosSegue",
            let cell = sender as? FriendCell,
            let destination = segue.destination as? PhotosViewController
        {
            destination.name = cell.titleLabel.text
            destination.friendID = cell.friendAvatar.userID!
        }
    }
}

extension FriendsViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return 1
        }
        return groupedByFirstLetterFriendsName.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredFriends.count
        }
        return groupedByFirstLetterFriendsName[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isFiltering {
            let headerName = ""
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerFirstLetter") as? SectionHeader else { fatalError() }
            header.headerLabelFirstLetter.text = headerName
            return header
        } else {
            let headerName = String(groupedByFirstLetterFriendsName[section][0].first!)
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerFirstLetter") as? SectionHeader else { fatalError() }
            header.headerLabelFirstLetter.text = headerName
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as? FriendCell else { fatalError() }
                
        if isFiltering {
            let friend = filteredFriends[indexPath.row]
            let friendAvatar = friend.friendAvatarURL
            guard let url = URL(string: friendAvatar), let data = try? Data(contentsOf: url) else { return cell }
            cell.titleLabel.text = friend.friendName
            cell.friendAvatarImage.image = UIImage(data: data)
            cell.friendAvatar.userID = filteredFriends[indexPath.row].friendID
        } else {
            guard let url = URL(string: groupedByFirstLetterFriendsURL[indexPath.section][indexPath.row]), let data = try? Data(contentsOf: url) else { return cell }
            let friendName = groupedByFirstLetterFriendsName[indexPath.section][indexPath.row]
            cell.titleLabel.text = friendName
            cell.friendAvatarImage.image = UIImage(data: data)
            cell.friendAvatar.tag = indexPath.row
            cell.friendAvatar.userID = groupedByFirstLetterFriendsID[indexPath.section][indexPath.row]
        }
        return cell
    }
}

extension FriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath)
    }
}

extension FriendsViewController:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    private func filterContentForSearchText(_ searchText: String) {
        filteredFriends = myFriends.filter({(friend: MyFriends) -> Bool in
            return friend.friendName.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

extension FriendsViewController {
    
    func loadFriendsFromNetWork() {
        networkService.loadFriendsCodable(token: Session.instance.token) { [weak self] result in
            switch result {
            case let .success(users):
                for user in users {
                    self?.friendsNamesFromNetwork.append("\(user.firstName) \(user.lastName)")
                    self?.friendsIDFromNetwork.append(user.id)
                    self?.avatarURLFromNetwork.append(user.photo100)
                }
                self?.friendsFromNetworkSorting()
                self?.tableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension FriendsViewController {
    func friendsFromNetworkSorting() {
        var characterForFiltering = friendsNamesFromNetwork[0].first!.lowercased()
        var wasSelectedArray: [String] = []
        var willSelectedArray: [String] = []
        var tempArray = friendsNamesFromNetwork
        var tempURLArray: [String] = []
        var tempIDArray: [Int] = []
        var count = 0
        var myFriendNameAndAvatar = MyFriends(friendName: "", friendAvatarURL: "", friendID: 0)
        
        while tempArray.count > 0 {
            for name in tempArray {
                if name.first?.lowercased() == characterForFiltering {
                    wasSelectedArray.append(name)
                    tempURLArray.append(avatarURLFromNetwork[count])
                    tempIDArray.append(friendsIDFromNetwork[count])
                    myFriendNameAndAvatar = MyFriends(friendName: name, friendAvatarURL: avatarURLFromNetwork[count], friendID: friendsIDFromNetwork[count])
                    myFriends.append(myFriendNameAndAvatar)
                    count += 1
                }
                if name.first?.lowercased() != characterForFiltering {
                    willSelectedArray.append(name)
                }
            }
            tempArray = willSelectedArray
            if tempArray.count > 0 {
                characterForFiltering = tempArray[0].first!.lowercased()
            }
            groupedByFirstLetterFriendsName.append(wasSelectedArray)
            groupedByFirstLetterFriendsURL.append(tempURLArray)
            groupedByFirstLetterFriendsID.append(tempIDArray)
            wasSelectedArray = []
            willSelectedArray = []
            tempURLArray = []
            tempIDArray = []
//            print(groupedByFirstLetterFriendsID)
        }
    }
}
