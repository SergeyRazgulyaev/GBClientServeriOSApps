//
//  GroupsViewController.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 09.07.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class GroupsViewController: BaseViewController {
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
    
    //MARK: - Properties for Interaction with Network
    private let networkService = NetworkService()
    
    //MARK: - Properties for Interaction with Database
    var groups = [FirebaseGroup]()
    var groupsRef = Database.database().reference(withPath: "authorizedUserGroup").child("user").child("groups")
    var groupsCollection = Firestore.firestore().collection("AutorizedUserGroups")
    var listener: ListenerRegistration?
    
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
        
        //MARK: - Function loadGroupsFromNetWork activation
        switch Config.databaseType {
        case .database:
            groupsRef.observe(.value) { [weak self] snapshot in
                self?.groups.removeAll()
                guard !snapshot.children.allObjects.isEmpty else {
                    self?.loadGroupsFromNetWork()
                    return
                }
                
                for child in snapshot.children {
                    guard let child = child as? DataSnapshot,
                        let group = FirebaseGroup(snapshot: child) else { continue }
                    self?.groups.append(group)

                }
//                print("groups \(String(describing: self?.groups))")
                self?.tableView.reloadData()
            }
            
        case .firestore:
            listener = groupsCollection.addSnapshotListener { [weak self] snapshot, error in
                self?.groups.removeAll()
                guard let snapshot = snapshot else { return }
                
                guard !snapshot.documents.isEmpty else {
                    self?.loadGroupsFromNetWork()
                    return
                }
                
                for document in snapshot.documents {
                    if let group = FirebaseGroup(dict: document.data()) {
                        self?.groups.append(group)
                    }
                }
                self?.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Deinit filteredGroupsNotificationToken
    deinit {
        switch Config.databaseType {
        case .database:
            groupsRef.removeAllObservers()
        case .firestore:
            listener?.remove()
        }
    }

    //MARK: - Add Group Block
    @IBAction func addGroup(_ sender: Any) {
        let alert = UIAlertController(title: "Добавить группу", message: nil, preferredStyle: .alert)
        alert.addTextField {(textField) in
            textField.placeholder = "Название группы"
        }
        let saveAction = UIAlertAction(title: "Ok", style: .default) { [weak self, weak alert] (action) in
            guard let firstText = alert?.textFields?.first?.text else { return }
            let group = FirebaseGroup(id: Int.random(in: 0...1_000_000), name: firstText, photo100: "https://sun1-14.userapi.com/impg/c858424/v858424322/13a01f/VQIFls1ldJA.jpg?size=100x0&quality=88&crop=0,0,1024,1024&sign=bab3698e77e5a193eacd49380e71e223&c_uniq_tag=OAdCz-KTdGnJTiKadj4wXx_80vVh442NtFY4msmmWxI&ava=1", screenName: "", type: "")
            let groupRef = self?.groupsRef.child(firstText.lowercased())
            groupRef?.setValue(group.toAnyObject())
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - Interaction with Network
extension GroupsViewController {
    func loadGroupsFromNetWork(completion: (() -> Void)? = nil) {
        networkService.loadGroups(token: Session.instance.token) { [weak self] result in
            switch result {
            case let .success(groups):
                
                DispatchQueue.main.async {
                    let firebaseGroups = groups.map { FirebaseGroup(from: $0) }
                    for group in firebaseGroups {
                        
                        switch Config.databaseType {
                        case .database:
                            self?.groupsRef.child("\(group.id)").setValue(group.toAnyObject())
                            
                        case .firestore:
                            self?.groupsCollection.document("\(group.id)").setData(group.toAnyObject())
                        }
                    }
                    self?.tableView.reloadData()
                    completion?()
                }
                
//                print(groups)
//                self?.tableView.reloadData()
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
        return groups.count
    }
    
    //MARK: - Cell For Row At IndexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as? GroupCell else { fatalError() }
        let group = groups[indexPath.row]
        let groupAvatar = group.photo100
        guard let url = URL(string: groupAvatar), let data = try? Data(contentsOf: url) else { return cell }
        cell.titleLabel.text = group.name
        cell.groupAvatarImage.image = UIImage(data: data)
        return cell
    }
    
    //MARK: - Delete Cell For Row At IndexPath Block
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let group = groups[indexPath.item]
            
            switch Config.databaseType {
            case .database:
                group.ref?.removeValue { [weak self] error, _ in
                    if let error = error {
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        self?.tableView.reloadData()
                    }
                }
                
            case .firestore:
                groupsCollection.document("\(group.id)").delete { [weak self] error in
                    if let error = error {
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        self?.tableView.reloadData()
                    }
                }
            }
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
