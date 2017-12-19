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

    @IBOutlet var canvasView: UIView!
    @IBOutlet var imageView: UIImageView!

    private var stickerView: UIImageView!
    private var stickerViewNeedsFirstResetPose = true

    @IBAction func resetPose(_ sender: Any) {
        let center = CGPoint(x: canvasView.bounds.midX, y: canvasView.bounds.midY)
        let size = stickerView.bounds.size
        stickerView.transform = .init(translationX: center.x - size.width / 2, y: center.y - size.height / 2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = #imageLiteral(resourceName: "aaaa")

        stickerView = makeStickerView(with: #imageLiteral(resourceName: "stickerHeart"), center: imageView.center)
        addGestures(to: stickerView)
        canvasView.addSubview(stickerView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if stickerViewNeedsFirstResetPose {
            stickerViewNeedsFirstResetPose = false
            resetPose(self)
        }
    }

    private func makeStickerView(with image: UIImage, center: CGPoint) -> UIImageView {
        let heightOnWidthRatio = image.size.height / image.size.width
        let imageWidth: CGFloat = 150

        //		let newStickerImageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: imageWidth, height: imageWidth * heightOnWidthRatio)))
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageWidth * heightOnWidthRatio))
        view.image = image
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.red.withAlphaComponent(0.7)
        view.layer.anchorPoint = .zero
        view.layer.position = .zero
        return view
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

    @objc private func stickerDidPinch(pincher: UIPinchGestureRecognizer) {
        guard let stickerView = pincher.view else { return }
        stickerView.transform = stickerView.transform.around(pincher.location(in: stickerView), do: { $0.scaledBy(x: pincher.scale, y: pincher.scale) })
        pincher.scale = 1
    }

    @objc private func stickerDidRotate(rotater: UIRotationGestureRecognizer) {
        guard let stickerView = rotater.view else { return }
        stickerView.transform = stickerView.transform.around(rotater.location(in: stickerView), do: { $0.rotated(by: rotater.rotation) })
        rotater.rotation = 0
    }

    @objc private func stickerDidMove(panner: UIPanGestureRecognizer) {
        guard let stickerView = panner.view else { return }

        let offset = panner.translation(in: stickerView)
        stickerView.transform = stickerView.transform.translatedBy(x: offset.x, y: offset.y)
        panner.setTranslation(.zero, in: stickerView)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "showResult": prepare(forShowResultSegue: segue)
        default: super.prepare(for: segue, sender: sender)
        }
    }

    private func prepare(forShowResultSegue segue: UIStoryboardSegue) {
        let vc = segue.destination as! ResultViewController
        vc.image = mergedImage()
    }

    private func mergedImage() -> UIImage? {
        guard let image = imageView.image else { return nil }

        var images: [(image: UIImage, viewSize: CGSize, transform: CGAffineTransform)] = []

        if let stickerViewImage = stickerView.image {
            images.append((image: stickerViewImage, viewSize: stickerView.bounds.size, transform: stickerView.transform))
        }

        return image.merge(in: imageView.frame.size, with: images)
    }
}



extension ViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer is UIPanGestureRecognizer || gestureRecognizer is UIRotationGestureRecognizer
    }
}
