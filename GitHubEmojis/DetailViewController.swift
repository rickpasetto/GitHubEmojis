//
//  DetailViewController.swift
//  GitHubEmojis
//
//  Created by Rick Pasetto on 11/11/16.
//  Copyright © 2016 Rick Pasetto. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!

    var imageLoader: URLImageLoader? = nil

    func configureView() {
        // Update the user interface for the detail item.
        if let emoji = self.detailItem {
            self.navigationItem.title = emoji.name
            imageLoader?.load(imageUrl: emoji.url, forKey: self.detailImageView?.hashValue ?? 0 ) {
                self.detailImageView?.image = $0
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Emoji? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

