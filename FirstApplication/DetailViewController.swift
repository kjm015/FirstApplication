//
//  DetailViewController.swift
//  XMLApplication
//
//  Created by Kevin Miyata on 9/21/18.
//  Copyright © 2018 Kevin Miyata. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    // Configure the elements within the detail view
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let imageView = self.albumImageView {
                // TODO: get valid album art link
                downloader!.downloadImage(urlString: detail.link) {
                    (image: UIImage?) in
                    imageView.image = image
                }
            }
            // TODO: populate description
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
            if let label = titleLabel {
                label.text = detail.title
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    // Set the class of the detail item to be a Song object
    var detailItem: Album? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    var downloader: Downloader?

}

