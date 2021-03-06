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
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.refreshControl = refreshControl
        }
    }
    
    //MARK: - Base properties
    private var indexPathForDelete: IndexPath?
    
    //MARK: - Properties for Interaction with Network
    private let networkService = NetworkService()
    
    //MARK: - Properties for Interaction with Database
    private var filteredGroupsNotificationToken: NotificationToken?
    private let realmManager = RealmManager.instance
    
    private var groupsFromRealm: Results<GroupItems>? {
        let groupsFromRealm: Results<GroupItems>? = realmManager?.getObjects()
        return groupsFromRealm
    }
    
    private var filteredGroups: Results<GroupItems>? {
        guard !searchText.isEmpty else { return groupsFromRealm }
        return groupsFromRealm?.filter("name CONTAINS[cd] %@", searchText)
    }
    
    private var searchText: String {
        searchBar.text ?? ""
    }
    
    //MARK: - Properties for SearchController
    private var isFiltering: Bool {
        return !searchText.isEmpty
    }
    
    //MARK: - Properties for RefreshController
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemGreen
        refreshControl.attributedTitle = NSAttributedString(string: "Reload Data", attributes: [.font: UIFont.systemFont(ofSize: 10)])
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNotification()
        
        //MARK: - Function loadGroupsFromNetWork activation
        if let groups = filteredGroups, groups.isEmpty {
            print("loadGroupsFromNetWork activated")
            loadGroupsFromNetWork()
        } else {
            print("loadGroupsFromNetWork is not active")
        }
    }
    
    //MARK: - Deinit filteredGroupsNotificationToken
    deinit {
        filteredGroupsNotificationToken?.invalidate()
    }
    
    //MARK: - Add Group Block
    @IBAction func addGroup(_ sender: Any) {
        let alert = UIAlertController(title: "Добавить группу", message: nil, preferredStyle: .alert)
        alert.addTextField {(textField) in
            textField.placeholder = "Название группы"
        }
        let action = UIAlertAction(title: "Ok", style: .default) { [weak self, weak alert] (action) in
            guard let firstText = alert?.textFields?.first?.text else { return }
            let group = GroupItems()
            group.id = Int.random(in: 0...1_000_000)
            group.name = firstText
            group.photo100 = "https://sun1-14.userapi.com/impg/c858424/v858424322/13a01f/VQIFls1ldJA.jpg?size=100x0&quality=88&crop=0,0,1024,1024&sign=bab3698e77e5a193eacd49380e71e223&c_uniq_tag=OAdCz-KTdGnJTiKadj4wXx_80vVh442NtFY4msmmWxI&ava=1"
            group.screenName = ""
            group.type = ""
            self?.addGroup(newGroup: group)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func addGroup(newGroup: GroupItems) {
        guard !newGroup.name.isEmpty else { return }
        try? realmManager?.add(object: newGroup)
    }
}

//MARK: - Interaction with Network
extension GroupsViewController {
    func loadGroupsFromNetWork(completion: (() -> Void)? = nil) {
        networkService.loadGroups(token: Session.instance.token) { [weak self] result in
            switch result {
            case let .success(groups):
                try? self?.realmManager?.add(objects: groups)
                completion?()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    //MARK: - Refresh Block
    @objc private func refresh(_ sender: UIRefreshControl) {
//        guard !isFiltering else {
//            self.refreshControl.endRefreshing()
//            return
//        }
        loadGroupsFromNetWork { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}

//MARK: - TableView Customization
extension GroupsViewController: UITableViewDataSource {
    
    //MARK: - Number Of Rows In Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGroups?.count ?? 0
    }
    
    //MARK: - Cell For Row At IndexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as? GroupCell else { fatalError() }
        let group = filteredGroups?[indexPath.row]
        let groupAvatar = group?.photo100 ?? ""
        guard let url = URL(string: groupAvatar), let data = try? Data(contentsOf: url) else { return cell }
        cell.titleLabel.text = group?.name
        cell.groupAvatarImage.image = UIImage(data: data)
        return cell
    }
    
    //MARK: - Delete Cell For Row At IndexPath Block
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            indexPathForDelete = indexPath
            guard let deletedGroup = filteredGroups?[indexPath.item] else { return }
            try? realmManager?.delete(object: deletedGroup)
        }
    }
}

//MARK: - Did Select Row At IndexPath
extension GroupsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - SearchController Block
extension GroupsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }
}

//MARK: - Alert Block
extension GroupsViewController {
    private func showAlert(title: String? = nil,
                           message: String? = nil,
                           handler: ((UIAlertAction) -> ())? = nil,
                           completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: completion)
    }
}

//MARK: - Function for observing filteredGroups changes
extension GroupsViewController {
    private func createNotification() {
        filteredGroupsNotificationToken = filteredGroups?.observe { [weak self] change in
            switch change {
            case let . initial(filteredGroups):
                print("Initialized \(filteredGroups.count)")
                
            case let .update(filteredGroups, deletions: deletions, insertions: insertions, modifications: modifications):
                print("""
                    New count: \(filteredGroups.count)
                    Deletions: \(deletions)
                    Insertions: \(insertions)
                    Modifications: \(modifications)
                    """)
                
                self?.tableView.reloadData()
                
//                self?.tableView.beginUpdates()
//
//                self?.tableView.deleteRows(at: deletions.map { _ in IndexPath(item: self!.indexPathForDelete!.item, section: 0) }, with: .automatic)
//                self?.tableView.insertRows(at: insertions.map { IndexPath(item: $0, section: 0) }, with: .automatic)
//                self?.tableView.reloadRows(at: modifications.map { IndexPath(item: $0, section: 0) }, with: .automatic)
//
//                self?.tableView.endUpdates()
                
            case let .error(error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
