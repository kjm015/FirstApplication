//
//  DetailViewController.swift
//  FirstApplication
//
//  Created by Kevin Miyata on 9/21/18.
//  Copyright © 2018 Kevin Miyata. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var titleLabel: UILabel!
    
    // Configure the elements within the detail view
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.artistName
            }
            if let label = titleLabel {
                label.text = detail.name
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    // Set the class of the detail item to be a Song object
    var detailItem: Song? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    var downloader: Downloader?

}

