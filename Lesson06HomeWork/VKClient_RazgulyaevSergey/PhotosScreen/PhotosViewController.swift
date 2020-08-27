//
//  PhotosViewController.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 09.07.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import UIKit
import RealmSwift

class PhotosViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var friendsName: UILabel!
    
    var name: String?
    let interactiveTransition = InteractiveTransition()
    
    private let networkService = NetworkService()
    private let realmManagerPhotos = RealmManager.instance
    
    private var allPhotosFromRealm: Results<PhotoItems>? {
        let photosFromRealm: Results<PhotoItems>? = realmManagerPhotos?.getObjects()
        return photosFromRealm
    }
    
    private var oneFriendPhotosFromRealm: Results<PhotoItems>? {
        let oneFriendPhotosFromRealm: Results<PhotoItems>? = realmManagerPhotos?.getObjects().filter("ownerID = \(friendID ?? -1)")
        return oneFriendPhotosFromRealm
    }

    var friendID: Int?
    var photosNumbersCount: Int = 1
    var timeSortedArray: [String] = []
    var photoNumbersArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        friendsName.text = name
        
        loadPhotosFromNetWork()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 200, height: 230)
        }
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        oneFriendPhotosFromRealm!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {fatalError()}
        guard let url = URL(string: ((oneFriendPhotosFromRealm?[indexPath.row])?.sizes.last?.url)!), let data = try? Data(contentsOf: url) else { return cell }
        cell.photoNumber.text = String(oneFriendPhotosFromRealm!.count)
        cell.photoCard.image = UIImage(data: data)
        cell.photoDate.text = dateTranslator(timeToTranslate: oneFriendPhotosFromRealm![indexPath.row].date)
        cell.heartView.heartLabel.text = String(oneFriendPhotosFromRealm![indexPath.row].likes!.count)
        cell.photoNumber.text = String("\(oneFriendPhotosFromRealm!.count - indexPath.row)")
        cell.userID = friendID
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(indexPath)
    }
}

extension PhotosViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PushAnimator()
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopAnimator()
    }
}

extension PhotosViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            if navigationController.viewControllers.first != toVC {
                interactiveTransition.viewController = toVC
                return PopAnimator()
            }
            return nil
        } else {
            if navigationController.viewControllers.first != fromVC {
                interactiveTransition.viewController = toVC
                return PushAnimator()
            }
            return nil
        }
    }
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
}

extension PhotosViewController {
    func loadPhotosFromNetWork() {
        networkService.loadPhotos(token: Session.instance.token, ownerID: friendID!, albumID: .profile, photoCount: 10) { [weak self] result in
            switch result {
            case let .success(photos):
                try? self?.realmManagerPhotos?.add(objects: photos)
                self?.collectionView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension PhotosViewController {
    func dateTranslator(timeToTranslate: Int) -> String {
        var date: Date?
            date = Date(timeIntervalSince1970: Double(timeToTranslate))
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: date!)
            return localDate
    }
}
