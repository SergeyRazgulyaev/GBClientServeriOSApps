//
//  PhotoCell.swift
//  VKClient_RazgulyaevSergey
//
//  Created by Sergey Razgulyaev on 09.07.2020.
//  Copyright © 2020 Sergey Razgulyaev. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var photoCard: UIImageView!
    @IBOutlet weak var photoNumber: UILabel!
    @IBOutlet weak var photoDate: UILabel!
    @IBOutlet weak var heartView: HeartView!
    @IBOutlet weak var photosViewController: UIViewController!
    @IBOutlet weak var friendName: UILabel!
    
    var interactiveAnimator: UIViewPropertyAnimator!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configure()
    }
    
    func configure() {
        photoCard.isUserInteractionEnabled = true
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        addGestureRecognizer(recognizer)
    }
    
    @objc func onTap(_ sender: Any?) {
        self.photosViewController.shouldPerformSegue(withIdentifier: "zoomPhotoSegue", sender: Any?.self)
        let vc = self.photosViewController.storyboard?.instantiateViewController(withIdentifier: "ZoomPhotoVC") as! ZoomPhotoViewController
        vc.friendZoomPhotoName = friendName.text
        vc.friendZoomPhotoCard = photoCard.image
        vc.friendZoomPhotoNumber = Int(photoNumber.text!)
        vc.transitioningDelegate = self.photosViewController as? UIViewControllerTransitioningDelegate
//      if need modal segue
//        self.photosViewController.present(vc, animated: true, completion: nil)
        print("Photo number \(photoNumber.text ?? "111")")
        self.photosViewController.navigationController?.delegate = self.photosViewController as? UINavigationControllerDelegate
        self.photosViewController.navigationController?.pushViewController(vc, animated: true)    }
        
        
    //        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
    //        self.photoCard.addGestureRecognizer(recognizer)
}

/*
 @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
 switch recognizer.state {
 case .began:
 interactiveAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
 self.photoCard.transform = .init(translationX: -200, y: 0)
 })
 interactiveAnimator.pauseAnimation()
 
 case .changed:
 let translation = recognizer.translation(in: self)
 interactiveAnimator.fractionComplete = translation.x / (-200)
 
 case .ended:
 interactiveAnimator.stopAnimation(true)
 interactiveAnimator.addAnimations {
 self.photoCard.transform = .identity
 }
 interactiveAnimator.startAnimation()
 default:
 return
 }
 }
 */

