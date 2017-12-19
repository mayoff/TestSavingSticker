    //
    //  Extensions.swift
    //  TestSavingSticker
    //
    //  Created by Nico on 19/12/2017.
    //  Copyright © 2017 Nico. All rights reserved.
    //

    import UIKit

    extension CGAffineTransform {
        func around(_ locus: CGPoint, do body: (CGAffineTransform) -> (CGAffineTransform)) -> CGAffineTransform {
            var transform = self.translatedBy(x: locus.x, y: locus.y)
            transform = body(transform)
            transform = transform.translatedBy(x: -locus.x, y: -locus.y)
            return transform
        }
    }

    extension UIImage {

        func merge(in viewSize: CGSize, with imageTuples: [(image: UIImage, viewSize: CGSize, transform: CGAffineTransform)]) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)

            print("scale : \(UIScreen.main.scale)")
            print("size : \(size)")
            print("--------------------------------------")

            guard let context = UIGraphicsGetCurrentContext() else { return nil }

            // Scale the context geometry to match the size of the image view that displayed me, because that's what all the transforms are relative to.
            context.scaleBy(x: size.width / viewSize.width, y: size.height / viewSize.height)

            draw(in: CGRect(origin: .zero, size: viewSize), blendMode: .normal, alpha: 1)

            for imageTuple in imageTuples {
                let areaRect = CGRect(origin: .zero, size: imageTuple.viewSize)

                context.saveGState()
                context.concatenate(imageTuple.transform)

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
