//
//  GroupsViewController.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 09.07.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import UIKit
import RealmSwift

class GroupsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let networkService = NetworkService()
    private let realmManager = RealmManager.instance
    
    private var groupsFromRealm: Results<GroupItems>? {
        let groupsFromRealm: Results<GroupItems>? = realmManager?.getObjects()
        return groupsFromRealm
    }
    
    var groupsNamesFromNetwork: [String] = []
    var groupsIDFromNetwork: [Int] = []
    var avatarURLFromNetwork: [String] = []
    
    private let searchGroupController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchGroupController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchGroupController.isActive && !searchBarIsEmpty
    }
    
    private var filteredGroups = [MyGroup]()
    private var groupedByFirstLetterGroupsName: [[String]] = []
    private var groupedByFirstLetterGroupsURL: [[String]] = []
    private var groupedByFirstLetterGroupsID: [[Int]] = []
    var myGroups: [MyGroup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGroupsFromNetWork()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchGroupController.searchResultsUpdater = self
        searchGroupController.obscuresBackgroundDuringPresentation = false
        searchGroupController.searchBar.placeholder = "Search My Groups"
        navigationItem.searchController = searchGroupController
        definesPresentationContext = true
        
        groupsNameIDAvatarArrayСreation()
        groupsFromNetworkSorting()
    }
    
    @IBAction func addGroup(_ sender: Any) {
        let alert = UIAlertController(title: "Добавить группу", message: nil, preferredStyle: .alert)
        alert.addTextField {(textField) in
            textField.placeholder = "Название группы"
        }
        let action = UIAlertAction(title: "Ok", style: .default) { [weak self, weak alert] (action) in
            guard let firstText = alert?.textFields?.first?.text else { return }
            self?.addGroup(newGroup: MyGroup.init(groupName: firstText, groupAvatarURL: "https://sun1-14.userapi.com/impg/c858424/v858424322/13a01f/VQIFls1ldJA.jpg?size=100x0&quality=88&crop=0,0,1024,1024&sign=bab3698e77e5a193eacd49380e71e223&c_uniq_tag=OAdCz-KTdGnJTiKadj4wXx_80vVh442NtFY4msmmWxI&ava=1", groupID: 0))
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func addGroup(newGroup: MyGroup) {
        guard !newGroup.groupName.isEmpty else { return }
        myGroups.insert(newGroup, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}

extension GroupsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredGroups.count
        }
        return myGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as? GroupCell else { fatalError() }
        
        if isFiltering {
            let group = filteredGroups[indexPath.row]
            let groupAvatar = group.groupAvatarURL
            guard let url = URL(string: groupAvatar), let data = try? Data(contentsOf: url) else { return cell }
            cell.titleLabel.text = group.groupName
            cell.groupAvatarImage.image = UIImage(data: data)
        } else {
            let group = myGroups[indexPath.row]
            let groupAvatar = group.groupAvatarURL
            guard let url = URL(string: groupAvatar), let data = try? Data(contentsOf: url) else { return cell }
            cell.titleLabel.text = group.groupName
            cell.groupAvatarImage.image = UIImage(data: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isFiltering {
                filteredGroups.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .top)
            } else {
                myGroups.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .top)
            }
        }
    }
}

extension GroupsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print(indexPath)
    }
}

extension GroupsViewController:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filteredGroups = myGroups.filter({(group: MyGroup) -> Bool in
            return group.groupName.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

extension GroupsViewController {
    
    func loadGroupsFromNetWork() {
        networkService.loadGroups(token: Session.instance.token) { [weak self] result in
            switch result {
            case let .success(groups):
                try? self?.realmManager?.add(objects: groups)
                self?.tableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension GroupsViewController {
    func groupsNameIDAvatarArrayСreation() {
        for group in groupsFromRealm! {
            groupsNamesFromNetwork.append(group.name)
            groupsIDFromNetwork.append(group.id)
            avatarURLFromNetwork.append(group.photo100)
        }
    }
    
    func groupsFromNetworkSorting() {
        guard groupsNamesFromNetwork.count > 0 else {
            print("Network error")
            return
        }
        
        var characterForFiltering = groupsNamesFromNetwork[0].first!.lowercased()
        var wasSelectedArray: [String] = []
        var willSelectedArray: [String] = []
        var tempArray = groupsNamesFromNetwork
        var tempURLArray: [String] = []
        var tempIDArray: [Int] = []
        var count = 0
        var myGroupNameAndAvatar = MyGroup(groupName: "", groupAvatarURL: "", groupID: 0)
        
        while tempArray.count > 0 {
            for name in tempArray {
                if name.first?.lowercased() == characterForFiltering {
                    wasSelectedArray.append(name)
                    tempURLArray.append(avatarURLFromNetwork[count])
                    tempIDArray.append(groupsIDFromNetwork[count])
                    myGroupNameAndAvatar = MyGroup(groupName: name, groupAvatarURL: avatarURLFromNetwork[count], groupID: groupsIDFromNetwork[count])
                    myGroups.append(myGroupNameAndAvatar)
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
            groupedByFirstLetterGroupsName.append(wasSelectedArray)
            groupedByFirstLetterGroupsURL.append(tempURLArray)
            groupedByFirstLetterGroupsID.append(tempIDArray)
            wasSelectedArray = []
            willSelectedArray = []
            tempURLArray = []
            tempIDArray = []
        }
    }
}
