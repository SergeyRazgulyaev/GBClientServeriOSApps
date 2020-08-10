//
//  GroupsViewController.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 09.07.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import UIKit

class GroupsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let searchGroupController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchGroupController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchGroupController.isActive && !searchBarIsEmpty
    }
    
    private var filteredGroups = [MyGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        searchGroupController.searchResultsUpdater = self
        searchGroupController.obscuresBackgroundDuringPresentation = false
        searchGroupController.searchBar.placeholder = "Search My Groups"
        navigationItem.searchController = searchGroupController
        definesPresentationContext = true
    }
    
    @IBAction func addGroup(_ sender: Any) {
        let alert = UIAlertController(title: "Добавить группу", message: nil, preferredStyle: .alert)
        alert.addTextField {(textField) in
            textField.placeholder = "Название группы"
        }
        let action = UIAlertAction(title: "Ok", style: .default) { [weak self, weak alert] (action) in
            guard let firstText = alert?.textFields?.first?.text else { return }
            self?.addGroup(newGroup: MyGroup.init(groupName: firstText, groupAvatar: UIImage(named: "ph003_50x")))
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
        
        var groups: MyGroup
        
        if isFiltering {
            groups = filteredGroups[indexPath.row]
        } else {
            groups = myGroups[indexPath.row]
        }
        
        cell.titleLabel.text = groups.groupName
        cell.groupAvatarImage.image = groups.groupAvatar
        
        print("Cell created for row: \(indexPath.row), \(myGroups[indexPath.row])")
        
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
        print(indexPath)
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
