//
//  PhotosViewController.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 09.07.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var friendsName: UILabel!
    
    var name: String?
    //    private var byFriendNameFilteredPhotos = [PhotosData]()
    let interactiveTransition = InteractiveTransition()
    
    let networkService = NetworkService()
    
    var friendID: Int?
    var photosFromNetworkURL: [String] = []
    var photosFromNetworkNumbers: [Int] = []
    var photosFromNetworkLikes: [Int] = []
    var photosNumbersCount: Int = 1
    var photosFromNetworkDates: [Int] = []
    var timeSortedArray: [String] = []
    var photoNumbersArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        friendsName.text = name
        
        let session = SessionUserID.instance
        friendID = session.friendIDFromSessionUserID
        //        print(friendID)
        
        loadPhotosFromNetWork()
        
        //        photoFilter()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 200, height: 230)
        }
        
    }
    
    //    func photoFilter() {
    //        for i in photos {
    //            if i.photoHolder == name {
    //                byFriendNameFilteredPhotos.append(i)
    //            }
    //        }
    //    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photosFromNetworkURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {fatalError()}
        
        guard let url = URL(string: photosFromNetworkURL[indexPath.row]), let data = try? Data(contentsOf: url) else { return cell }
        cell.photoNumber.text = String(photosFromNetworkURL.count)
        cell.photoCard.image = UIImage(data: data)
        cell.photoDate.text = timeSortedArray[indexPath.row]
        cell.heartView.heartLabel.text = String(photosFromNetworkLikes[indexPath.row])
        cell.photoNumber.text = String("\(photoNumbersArray[indexPath.row])")
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        
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
        networkService.loadPhotosCodable(token: Session.instance.token, ownerID: friendID!, albumID: .profile, photoCount: 10) { [weak self] result in
            switch result {
            case let .success(photos):
                for photo in photos {
                    self?.photosFromNetworkURL.append((photo.sizes?.last?.url)!)
                    self?.photosFromNetworkLikes.append((photo.likes?.count)!)
                    self?.photosFromNetworkDates.append((photo.date!))
                }
//                print(photos)
                self!.dateTranslator(timeArray: self!.photosFromNetworkDates)
                self!.photoNumbersArrayCreator(photoCount: photos.count)
                self?.collectionView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension PhotosViewController {
    func dateTranslator(timeArray: [Int]) {
        var date: Date?
        for time in timeArray {
            date = Date(timeIntervalSince1970: Double(time))
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: date!)
            timeSortedArray.append(localDate)
        }
    }
}

extension PhotosViewController {
    func photoNumbersArrayCreator(photoCount: Int) {
        var tempArray: [Int] = []
        guard photoCount != 0 else {
            return
        }
        for i in 1...photoCount {
            tempArray.append(i)
        }
        photoNumbersArray = tempArray.sorted(by: {$1<$0})
    }
}
