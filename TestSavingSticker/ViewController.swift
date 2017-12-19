//
//  ViewController.swift
//  TestSavingSticker
//
//  Created by Nico on 19/12/2017.
//  Copyright © 2017 Nico. All rights reserved.
//

import UIKit
import Photos



class ViewController: UIViewController {

	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var imageView: UIImageView!
	
	private var stickerView: UIImageView!
	
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.layoutIfNeeded()
		
		imageView.image = #imageLiteral(resourceName: "aaaa")
		stickerView = createStickerImageView(with: #imageLiteral(resourceName: "stickerHeart"), center: imageView.center)
		addGestures(to: stickerView)
		
		view.addSubview(stickerView)
	}

	

	private func createStickerImageView(with image: UIImage, center: CGPoint) -> UIImageView {
		let heightOnWidthRatio = image.size.height / image.size.width
		let imageWidth: CGFloat = 150
		
		//		let newStickerImageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: imageWidth, height: imageWidth * heightOnWidthRatio)))
		let newStickerImageView = UIImageView(frame: CGRect(center: center, size: CGSize(width: imageWidth, height: imageWidth * heightOnWidthRatio)))
		newStickerImageView.image = image
		newStickerImageView.clipsToBounds = true
		newStickerImageView.contentMode = .scaleAspectFit
		newStickerImageView.isUserInteractionEnabled = true
		newStickerImageView.backgroundColor = UIColor.red.withAlphaComponent(0.7)
		
		return newStickerImageView
	}
	
	private func addGestures(to stickerView: UIImageView) {
		let stickerPanGesture = UIPanGestureRecognizer(target: self, action: #selector(stickerDidMove))
		let stickerPinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(stickerDidPinch))
		let stickerRotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(stickerDidRotate))
		
		stickerPinchGesture.delegate = self
		stickerRotateGesture.delegate = self
		
		stickerView.addGestureRecognizer(stickerPinchGesture)
		stickerView.addGestureRecognizer(stickerRotateGesture)
		stickerView.addGestureRecognizer(stickerPanGesture)
	}
	
	@objc private func stickerDidPinch(sender: UIPinchGestureRecognizer) {
		guard let view = sender.view else { return }
		
		view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
		sender.scale = 1
	}
	
	@objc private func stickerDidRotate(sender: UIRotationGestureRecognizer) {
		guard let view = sender.view else { return }
		
		view.transform = view.transform.rotated(by: sender.rotation)
		sender.rotation = 0
	}
	
	@objc private func stickerDidMove(sender: UIPanGestureRecognizer) {
		guard let stickerView = sender.view else { return }
		
		stickerView.transform = stickerView.transform.translatedBy(x: sender.translation(in: stickerView).x, y: sender.translation(in: stickerView).y)
		sender.setTranslation(.zero, in: stickerView)
	}
	
	 
	
	@IBAction func saveButtonDidPress(_ sender: UIButton) {
		guard let image = getMergedImage() else { return }
		
		saveImage(image)
	}
	
	private func getMergedImage() -> UIImage? {
		guard let image = imageView.image else { return nil }
		
		var images: [(image: UIImage, viewSize: CGSize, transform: CGAffineTransform)] = [] 
		
		if let stickerViewImage = stickerView.image {
				images.append((image: stickerViewImage, viewSize: stickerView.bounds.size, transform: stickerView.transform))
			}
		
		return image.merge(in: imageView.frame, with: images)
	}
	
	
	private func saveImage(_ image: UIImage) {
		guard let data = UIImageJPEGRepresentation(image, 1) else { return }
		
		PHPhotoLibrary.requestAuthorization { status in
			guard status == .authorized else { return }
			
			PHPhotoLibrary.shared().performChanges({
				let creationRequest = PHAssetCreationRequest.forAsset()
				creationRequest.addResource(with: .photo, data: data, options: nil)
			}, completionHandler: { _, error in
				if let error = error {
					print("Error occurered while saving photo to photo library: \(error)")
				}
				
				print("Saveddddddddddddddddddddddddddddddddddddddddd")
			})
		}	
	}
}



extension ViewController: UIGestureRecognizerDelegate {
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return gestureRecognizer is UIPanGestureRecognizer || gestureRecognizer is UIRotationGestureRecognizer
	}
}
