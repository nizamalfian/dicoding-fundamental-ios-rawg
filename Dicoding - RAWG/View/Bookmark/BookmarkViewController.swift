//
//  BookmarkViewController.swift
//  Dicoding - RAWG
//
//  Created by Amirul Nizam Alfian on 13/10/20.
//  Copyright © 2020 Amirul Nizam Alfian. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var emptyState: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton("Bookmarks")
        showLoading()
    }
    
    private func showLoading() {
        self.loading.startAnimating()
        self.loading.isHidden = false
        self.tableView.isHidden = true
        hideEmpty()
    }
    
    private func hideLoading() {
        self.loading.stopAnimating()
        self.loading.isHidden = true
        self.tableView.isHidden = false
    }
    
    private func showEmpty() {
        emptyState.isHidden = false
    }
    
    private func hideEmpty() {
        emptyState.isHidden = true
    }

}
