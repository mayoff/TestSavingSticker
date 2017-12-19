//
//  ResultViewController.swift
//  TestSavingSticker
//
//  Created by Rob Mayoff on 12/19/17.
//  Copyright © 2017 Nico. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    var image: UIImage?
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }

}
