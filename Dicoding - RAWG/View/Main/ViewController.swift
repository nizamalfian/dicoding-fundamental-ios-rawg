//
//  ViewController.swift
//  Dicoding - RAWG
//
//  Created by Amirul Nizam Alfian on 13/09/20.
//  Copyright © 2020 Amirul Nizam Alfian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageInfo: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var games = [GameItem]()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setLeftAlignedNavigationItemTitle("RAWG Video Games", 10)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoading()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        loadData()
    }
    
    private func loadData() {
        let components = URLComponents(string: "https://api.rawg.io/api/games")!
        let request = URLRequest(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, let data = data else { return }
            if (response.statusCode == 200) {
                self.decodeJson(data: data)
            } else {
                print("ERROR: \(data), HTTP Status: \(response.statusCode)")
            }
        }
        task.resume()
    }
    
    private func showLoading() {
        self.loading.startAnimating()
        self.loading.isHidden = false
        self.tableView.isHidden = true
    }
    
    private func hideLoading() {
        self.loading.stopAnimating()
        self.loading.isHidden = true
        self.tableView.isHidden = false
    }
    
    private func decodeJson(data: Data) {
        let decoder = JSONDecoder()
        let gameResponse = try! decoder.decode(GameResponse.self, from: data)
        self.games = gameResponse.games
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.hideLoading()
        }
    }
    @IBAction func onBookmarkClicked(_ sender: UIBarButtonItem) {
        let bookmark = BookmarkViewController(nibName: "BookmarkViewController", bundle: nil)
        self.navigationController?.pushViewController(bookmark, animated: true)
    }
    
    @IBAction func onInfoClicked(_ sender: UIBarButtonItem) {
        let about = AboutViewController(nibName: "AboutViewController", bundle: nil)
        self.navigationController?.pushViewController(about, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {
            cell.setData(games[indexPath.row], alertDelegate: self)
            
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
    
}

extension UIImageView {
    func loadImage(url urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}

extension ViewController {
    func setLeftAlignedNavigationItemTitle(_ text: String,
                                           _ margin: CGFloat) {
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Poppins-Bold", size: 18)
        
        self.navigationItem.titleView = titleLabel
        
        guard let containerView = self.navigationItem.titleView?.superview else { return }
        
        let leftBarItemWidth = self.navigationItem.leftBarButtonItems?.reduce(0, { $0 + $1.width })
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor,
                                             constant: (leftBarItemWidth ?? 0) + margin)
        ])
    }
}
