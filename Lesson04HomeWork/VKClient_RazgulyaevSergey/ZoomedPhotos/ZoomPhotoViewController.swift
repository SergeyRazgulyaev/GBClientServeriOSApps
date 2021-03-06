//
//  ZoomPhotoViewController.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 27.07.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import UIKit

class ZoomPhotoViewController: UIViewController {
    @IBOutlet weak var zoomedFriendsPhoto: UIImageView!
    @IBOutlet weak var zoomedNextFriendPhoto: UIImageView!
    
    var photos: [PhotoData] = []
    var friendZoomPhotoName: String?
    var friendZoomPhotoCard: UIImage?
    var friendZoomPhotoNumber: Int?
    var zoomPhotoIndex: Int?
    var friendID: Int?
    var photosFromNetworkURL: [String] = []
    var photoNumbersArray: [Int] = []
    var previousImage: UIImage? = UIImage(systemName: "tortoise")
    var shownImage: UIImage? = UIImage(systemName: "hare")
    var nextImage: UIImage? = UIImage(systemName: "hare")
    
    let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotosFromNetWork()
        zoomedFriendsPhoto.isUserInteractionEnabled = true
        zoomedNextFriendPhoto.isUserInteractionEnabled = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture(_:)))
        swipeRight.direction = .right
        zoomedFriendsPhoto.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture(_:)))
        swipeLeft.direction = .left
        zoomedFriendsPhoto.addGestureRecognizer(swipeLeft)
    }
    
    @objc func swipeGesture(_ sender: UISwipeGestureRecognizer?) {
        if let swipeGesture = sender {
            switch swipeGesture.direction {
            case .right:
                if zoomPhotoIndex! == 0 {
                    print("No elements to swipe")
                }
                if zoomPhotoIndex! > 0 && zoomPhotoIndex! < (photosFromNetworkURL.count - 1)  {
                    guard let previousImageURL = URL(string: photosFromNetworkURL[zoomPhotoIndex!-1]), let previousImageData = try? Data(contentsOf: previousImageURL) else { return }
                    guard let shownImageURL = URL(string: photosFromNetworkURL[zoomPhotoIndex!]), let shownImageData = try? Data(contentsOf: shownImageURL) else { return }
                    previousImage = UIImage(data: previousImageData)
                    shownImage = UIImage(data: shownImageData)
                    print("Swipe right")
                    photosReverseAnimation()
                }
                if zoomPhotoIndex! == (photosFromNetworkURL.count - 1) {
                    guard let previousImageURL = URL(string: photosFromNetworkURL[zoomPhotoIndex!-1]), let previousImageData = try? Data(contentsOf: previousImageURL) else { return }
                    guard let shownImageURL = URL(string: photosFromNetworkURL[zoomPhotoIndex!]), let shownImageData = try? Data(contentsOf: shownImageURL) else { return }
                    guard photosFromNetworkURL.count > 1 else { return }
                    previousImage = UIImage(data: previousImageData)
                    shownImage = UIImage(data: shownImageData)
                    print("Swipe right")
                    photosReverseAnimation()
                }
            case .left:
                
                if zoomPhotoIndex! == 0 {
                    guard let nextImageURL = URL(string: photosFromNetworkURL[zoomPhotoIndex!+1]), let nextImageData = try? Data(contentsOf: nextImageURL) else { return }
                    guard let shownImageURL = URL(string: photosFromNetworkURL[zoomPhotoIndex!]), let shownImageData = try? Data(contentsOf: shownImageURL) else { return }
                    guard photosFromNetworkURL.count > 1 else { return }
                    nextImage = UIImage(data: nextImageData)
                    shownImage = UIImage(data: shownImageData)
                    print("Swipe left")
                    photosAnimation()
                }
                if zoomPhotoIndex! > 0 && zoomPhotoIndex! < (photosFromNetworkURL.count - 1)  {
                    guard let nextImageURL = URL(string: photosFromNetworkURL[zoomPhotoIndex!+1]), let nextImageData = try? Data(contentsOf: nextImageURL) else { return }
                    guard let shownImageURL = URL(string: photosFromNetworkURL[zoomPhotoIndex!]), let shownImageData = try? Data(contentsOf: shownImageURL) else { return }
                    nextImage = UIImage(data: nextImageData)
                    shownImage = UIImage(data: shownImageData)
                    print("Swipe left")
                    photosAnimation()
                }
                if zoomPhotoIndex! == photosFromNetworkURL.count - 1 {
                    print("No elements to swipe")
                }
            default:
                break
            }
        }
    }
    
    func photosAnimation() {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.zoomPhotoIndex! += 1
        })
        
        zoomedNextFriendPhoto.image = nextImage
        zoomedFriendsPhoto.image = shownImage
        
        let animationTransformScale = CASpringAnimation(keyPath: "transform.scale")
        animationTransformScale.duration = 1
        animationTransformScale.fromValue = 1
        animationTransformScale.toValue = 0.9
        animationTransformScale.stiffness = 100
        animationTransformScale.mass = 0.3
        animationTransformScale.fillMode = CAMediaTimingFillMode.both
        animationTransformScale.isRemovedOnCompletion = false
        zoomedFriendsPhoto.layer.add(animationTransformScale, forKey: nil)
        
        let animationTransform = CABasicAnimation(keyPath: "position.x")
        animationTransform.duration = 1
        animationTransform.fromValue = zoomedNextFriendPhoto.frame.width * 2
        animationTransform.toValue = zoomedNextFriendPhoto.frame.width / 2
        animationTransform.fillMode = CAMediaTimingFillMode.both
        animationTransform.isRemovedOnCompletion = false
        zoomedNextFriendPhoto.layer.add(animationTransform, forKey: nil)
        
        CATransaction.commit()
    }
    
    func photosReverseAnimation() {
        zoomedNextFriendPhoto.image = shownImage
        zoomedFriendsPhoto.image = previousImage
        zoomPhotoIndex! -= 1
        
        let animationTransformScale = CASpringAnimation(keyPath: "transform.scale")
        animationTransformScale.duration = 1
        animationTransformScale.fromValue = 0.9
        animationTransformScale.toValue = 1
        animationTransformScale.stiffness = 100
        animationTransformScale.mass = 0.3
        animationTransformScale.fillMode = CAMediaTimingFillMode.both
        animationTransformScale.isRemovedOnCompletion = false
        zoomedFriendsPhoto.layer.add(animationTransformScale, forKey: nil)
        
        let animationTransform = CABasicAnimation(keyPath: "position.x")
        animationTransform.duration = 1
        animationTransform.fromValue = zoomedNextFriendPhoto.frame.width / 2
        animationTransform.toValue = zoomedNextFriendPhoto.frame.width * 2
        animationTransform.fillMode = CAMediaTimingFillMode.both
        animationTransform.isRemovedOnCompletion = false
        zoomedNextFriendPhoto.layer.add(animationTransform, forKey: nil)
        
    }
    
    func calculationOfZoomPhotoIndex() {
        guard friendZoomPhotoNumber != nil else {
            friendZoomPhotoNumber = 1
            zoomPhotoIndex = 0
            return
        }
        zoomPhotoIndex = photosFromNetworkURL.count - friendZoomPhotoNumber!
    }
    
    func showZoomPhotos() {
        guard let zoomedFriendsPhotoURL = URL(string: photosFromNetworkURL[zoomPhotoIndex!]), let zoomedFriendsPhotoData = try? Data(contentsOf: zoomedFriendsPhotoURL) else { return }
        if zoomPhotoIndex! < (photosFromNetworkURL.count - 1) && zoomPhotoIndex! >= 0 {
            guard let zoomedNextFriendsPhotoURL = URL(string: photosFromNetworkURL[zoomPhotoIndex! + 1]), let zoomedNextFriendsPhotoData = try? Data(contentsOf: zoomedNextFriendsPhotoURL) else { return }
            zoomedFriendsPhoto.image = UIImage(data: zoomedFriendsPhotoData)
            zoomedNextFriendPhoto.image = UIImage(data: zoomedNextFriendsPhotoData)
        }
        if zoomPhotoIndex! == (photosFromNetworkURL.count - 1) {
            guard let zoomedNextFriendsPhotoURL = URL(string: photosFromNetworkURL[0]), let zoomedNextFriendsPhotoData = try? Data(contentsOf: zoomedNextFriendsPhotoURL) else { return }
            zoomedFriendsPhoto.image = UIImage(data: zoomedFriendsPhotoData)
            zoomedNextFriendPhoto.image = UIImage(data: zoomedNextFriendsPhotoData)
        }
        else { return }
    }
}

extension ZoomPhotoViewController {
    func loadPhotosFromNetWork() {
        guard friendID != nil else {
            zoomedFriendsPhoto.image = UIImage(systemName: "tortoise")
            print("Oops!")
            return
        }
        networkService.loadPhotosCodable(token: Session.instance.token, ownerID: friendID!, albumID: .profile, photoCount: 10) { [weak self] result in
            switch result {
            case let .success(photos):
                for photo in photos {
                    self?.photosFromNetworkURL.append((photo.sizes.last?.url)!)
                    self!.photoNumbersArrayCreator(photoCount: photos.count)
                }
                self?.calculationOfZoomPhotoIndex()
                self?.showZoomPhotos()
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension ZoomPhotoViewController {
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
