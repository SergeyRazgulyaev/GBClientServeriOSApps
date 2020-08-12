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
    
    private var forZoomPhotos = [PhotosData]()
    var friendZoomPhotoName: String?
    var friendZoomPhotoCard: UIImage?
    var friendZoomPhotoNumber: Int?
    var zoomPhotoIndex: Int?
    
    var previousImage: UIImage? = UIImage(systemName: "tortoise")
    var shownImage: UIImage? = UIImage(systemName: "hare")
    var nextImage: UIImage? = UIImage(systemName: "hare")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zoomPhotoFilter()
        calculationOfZoomPhotoIndex()
        //        zoomPhotoIndex = forZoomPhotos.count - friendZoomPhotoNumber!
        showZoomPhotos()
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
                if zoomPhotoIndex! > 0 && zoomPhotoIndex! < (forZoomPhotos.count - 1)  {
                    previousImage = forZoomPhotos[zoomPhotoIndex!-1].photoCard
                    shownImage = forZoomPhotos[zoomPhotoIndex!].photoCard
                    print("Swipe right")
                    photosReverseAnimation()
                }
                if zoomPhotoIndex! == (forZoomPhotos.count - 1) {
                    guard forZoomPhotos.count > 1 else { return }
                    previousImage = forZoomPhotos[zoomPhotoIndex!-1].photoCard
                    shownImage = forZoomPhotos[zoomPhotoIndex!].photoCard
                    print("Swipe right")
                    photosReverseAnimation()
                }
            case .left:
                if zoomPhotoIndex! == 0 {
                    guard forZoomPhotos.count > 1 else { return }
                    nextImage = forZoomPhotos[zoomPhotoIndex!+1].photoCard
                    shownImage = zoomedFriendsPhoto.image
                    print("Swipe left")
                    photosAnimation()
                }
                if zoomPhotoIndex! > 0 && zoomPhotoIndex! < (forZoomPhotos.count - 1)  {
                    nextImage = forZoomPhotos[zoomPhotoIndex!+1].photoCard
                    shownImage = forZoomPhotos[zoomPhotoIndex!].photoCard
                    print("Swipe left")
                    photosAnimation()
                }
                if zoomPhotoIndex! == forZoomPhotos.count - 1 {
                    print("No elements to swipe")
                }
            default:
                break
            }
        }
    }
    
    func calculationOfZoomPhotoIndex() {
        guard friendZoomPhotoNumber != nil else {
            friendZoomPhotoNumber = 1
            zoomPhotoIndex = 0
            return
        }
        zoomPhotoIndex = forZoomPhotos.count - friendZoomPhotoNumber!
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
    
    func zoomPhotoFilter() {
        guard friendZoomPhotoName != nil else {
            friendZoomPhotoName = "Tortoise"
            forZoomPhotos.append(photos[photos.count - 1])
            return
        }
        for i in photos {
            if i.photoHolder == friendZoomPhotoName {
                forZoomPhotos.append(i)
            }
        }
    }
    
    func showZoomPhotos() {
        if zoomPhotoIndex! < (forZoomPhotos.count - 1) && zoomPhotoIndex! >= 0 {
            zoomedFriendsPhoto.image = forZoomPhotos[zoomPhotoIndex!].photoCard
            zoomedNextFriendPhoto.image = forZoomPhotos[zoomPhotoIndex! + 1].photoCard
        }
        if zoomPhotoIndex! == (forZoomPhotos.count - 1) {
            zoomedFriendsPhoto.image = forZoomPhotos[zoomPhotoIndex!].photoCard
            zoomedNextFriendPhoto.image = forZoomPhotos[0].photoCard
        }
        else {return}
    }
//    @IBAction func closeButtonOn(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
}
