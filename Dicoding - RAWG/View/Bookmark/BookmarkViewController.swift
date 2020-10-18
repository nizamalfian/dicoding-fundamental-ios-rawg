//
//  BookmarkViewController.swift
//  Dicoding - RAWG
//
//  Created by Amirul Nizam Alfian on 13/10/20.
//  Copyright © 2020 Amirul Nizam Alfian. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BookmarkGameDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var emptyState: UIStackView!
    private var gameProvider: GameProvider = { return GameProvider() }()
    
    private var games = [GameItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar("Bookmarks")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    private func loadData() {
        showLoading()
        gameProvider.getAllGames { (games) in
            DispatchQueue.main.async {
                if games.isEmpty {
                    self.showEmpty()
                    self.hideLoading()
                    return
                }
                
                self.showData(games)
                self.hideLoading()
            }
        }
    }
    
    private func showData(_ games: [GameItem]) {
        self.tableView.isHidden = false
        self.games = games
        self.tableView.reloadData()
    }
    
    private func showLoading() {
        self.loading.startAnimating()
        self.loading.isHidden = false
        self.tableView.isHidden = true
        self.hideEmpty()
    }
    
    private func hideLoading() {
        self.loading.stopAnimating()
        self.loading.isHidden = true
    }
    
    private func showEmpty() {
        self.emptyState.isHidden = false
        self.tableView.isHidden = true
    }
    
    private func hideEmpty() {
        self.emptyState.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {
            cell.setData(games[indexPath.row], alertDelegate: self, self)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detail = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detail.gameItem = games[indexPath.row]
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func refreshData() {
        loadData()
    }
}
