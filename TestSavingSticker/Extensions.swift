//
//  Extensions.swift
//  TestSavingSticker
//
//  Created by Nico on 19/12/2017.
//  Copyright © 2017 Nico. All rights reserved.
//

import UIKit




extension CGRect {
	
	init(center: CGPoint, size: CGSize) {
		let origin = CGPoint(x: center.x - size.width/2, y: center.y - size.height/2)
		
		self.init(origin: origin, size: size)
	}
}



extension UIImage {
	
	func merge(in rect: CGRect, with imageTuples: [(image: UIImage, viewSize: CGSize, transform: CGAffineTransform)]) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
		
		print("scale : \(UIScreen.main.scale)")
		print("size : \(size)")
		print("--------------------------------------")
		
		guard let context = UIGraphicsGetCurrentContext() else { return nil }
		
		draw(in: CGRect(origin: .zero, size: size), blendMode: .normal, alpha: 1)
		
		// Those multiplicators are used to properly scale the transform of each sub image as the parent image (self) might be bigger than its view bounds, same goes for the subviews
		let xMultiplicator = size.width / rect.width
		let yMultiplicator = size.height / rect.height
		
		for imageTuple in imageTuples {
			let size = CGSize(width: imageTuple.viewSize.width * xMultiplicator, height: imageTuple.viewSize.height * yMultiplicator)
			let center = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
			let areaRect = CGRect(center: center, size: size)
			
			context.saveGState() 
			
			let transform = imageTuple.transform
			
			context.translateBy(x: center.x, y: center.y)
			context.concatenate(transform)
			context.translateBy(x: -center.x, y: -center.y)
			
			context.setBlendMode(.color)
			UIColor.purple.withAlphaComponent(0.5).setFill()
			context.fill(areaRect)
			
			imageTuple.image.draw(in: areaRect, blendMode: .normal, alpha: 1)
			
			context.restoreGState()
		}
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image
	}
}
