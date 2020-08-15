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
    
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var filteredFriends = [MyFriends]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        }
    }
}

extension FriendsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return 1
        }
        return groupedByFirstLetterFriends.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredFriends.count
        }
        return groupedByFirstLetterFriends[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isFiltering {
            let headerName = ""
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerFirstLetter") as? SectionHeader else { fatalError() }
            header.headerLabelFirstLetter.text = headerName
            return header
        } else {
        let headerName = String(groupedByFirstLetterFriends[section][0].friendName.first!)
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerFirstLetter") as? SectionHeader else { fatalError() }
        header.headerLabelFirstLetter.text = headerName
        return header
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as? FriendCell else { fatalError() }
        
        var friends: MyFriends
        
        if isFiltering {
            friends = filteredFriends[indexPath.row]
        } else {
            friends = groupedByFirstLetterFriends[indexPath.section][indexPath.row]
        }
        
        cell.titleLabel.text = friends.friendName
        cell.friendAvatarImage.image = friends.friendAvatar
        print("Cell created for row: \(indexPath.row), \(groupedByFirstLetterFriends[indexPath.section])")
        
        return cell
    }
}

extension FriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
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
