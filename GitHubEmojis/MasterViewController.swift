//
//  MasterViewController.swift
//  GitHubEmojis
//
//  Created by Rick Pasetto on 11/11/16.
//  Copyright © 2016 Rick Pasetto. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var imageLoader: URLImageLoader? = nil

    let model = Model(fetcher: URLFetcher(url: GitHubURL))

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageLoader = URLImageLoader()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        self.refreshControl?.addTarget(self, action: #selector(MasterViewController.handleRefresh(_:)),
                                       for: UIControlEvents.valueChanged)
        refresh{}
    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.model.flush()
        self.tableView.reloadData()

        refresh {
            refreshControl.endRefreshing()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = model[indexPath.row]
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.imageLoader = imageLoader
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let emoji = model[indexPath.row]
        cell.textLabel?.text = emoji.name
        cell.imageView?.image = UIImage(named: "DefaultImage")

        imageLoader?.load(imageUrl: emoji.url, forKey: cell.imageView?.hashValue ?? 0) { image in
            cell.imageView?.image = image
            cell.setNeedsLayout()
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    // MARK: - Private functions

    private func refresh(completion: @escaping ()->Void){
        model.refreshData(
            dataReady: {
                self.tableView.reloadData()
                completion()
        },
            dataError: { error in
                self.showAlert(error)
                completion()
        })
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: "Failed to load: \(message)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

