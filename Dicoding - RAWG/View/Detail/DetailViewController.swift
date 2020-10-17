//
//  DetailViewController.swift
//  Dicoding - RAWG
//
//  Created by Amirul Nizam Alfian on 23/09/20.
//  Copyright © 2020 Amirul Nizam Alfian. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    private lazy var gameProvider: GameProvider = { return GameProvider() }()
    var gameItem: GameItem?
    private var isBookmarked: Bool?
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var publishers: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setData()
    }
    
    private func setData() {
        if let game = gameItem {
            setBookmarkState(gameId: game.id)
            setNavigationBar(game.name)
            self.img.loadImage(url: game.imgUrl)
            self.rating.text = String(format: "%.2f", game.rating)
            self.releaseDate.text = game.releaseDate
            self.scrollView.updateContentView()
        }
    }
    
    private func setButtonBar(bookmarked: Bool) {
        let imageAssetName: String
        if bookmarked {
            imageAssetName = "ic_bookmark_red"
        } else {
            imageAssetName = "ic_unbookmark_red"
        }
        
        self.navigationItem.rightBarButtonItem = menuButton(self, action: #selector(onBookmarkClicked), imageName: imageAssetName)
        self.isBookmarked = bookmarked
    }
    
    @objc func onBookmarkClicked() {
        if let game = self.gameItem {
            if let bookmarked = self.isBookmarked {
                if bookmarked {
                    self.showAlert(message: "Are you sure want to unbookmark this game?", positiveConfirmation: "Yes", negativeConfirmation: "Cancel") {
                        self.gameProvider.deleteGame(game.id) {
                            DispatchQueue.main.async {
                                self.setButtonBar(bookmarked: false)
                                self.showToast(message: "Unbookmarked!")
                            }
                        }
                    }
                } else {
                    self.gameProvider.createGame(game.id, game.imgUrl, game.name, game.rating, game.releaseDate) {
                        DispatchQueue.main.async {
                            self.setButtonBar(bookmarked: true)
                            self.showToast(message: "Bookmarked!")
                        }
                    }
                }
            }
        }
    }
    
    private func setBookmarkState(gameId: Int) {
        self.gameProvider.getGameBookmarkState(gameId) { (bookmarked) in
            DispatchQueue.main.async {
                self.setButtonBar(bookmarked: bookmarked)
            }
        }
    }
    
    private func loadData() {
        if let gameId = gameItem?.id {
            let components = URLComponents(string: "https://api.rawg.io/api/games/\(gameId)")!
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
    }
    
    private func decodeJson(data: Data) {
        if let gameDetailResponse = try? JSONDecoder().decode(GameDetailResponse.self, from: data) {
            DispatchQueue.main.async {
                self.website.text = gameDetailResponse.website
                self.desc.text = gameDetailResponse.description
                
                var genres = "-"
                if gameDetailResponse.genres.isEmpty == false {
                    genres = ""
                    gameDetailResponse.genres.enumerated().forEach { (index, item) in
                        let separator: String
                        if index == gameDetailResponse.genres.count - 1 {
                            separator = ""
                        } else {
                            separator = ", "
                        }
                        
                        genres = genres + item.name + separator
                        self.genres.text = genres
                    }
                }
                
                var publishers = "-"
                if gameDetailResponse.publishers.isEmpty == false {
                    publishers = ""
                    gameDetailResponse.publishers.enumerated().forEach { (index, item) in
                        let separator: String
                        if index == gameDetailResponse.publishers.count - 1 {
                            separator = ""
                        } else {
                            separator = ", "
                        }
                        
                        publishers = publishers + item.name + separator
                        self.publishers.text = publishers
                    }
                }
                self.scrollView.updateContentView()
            }
        }
    }

}

extension UIViewController {
    func setNavigationBar(_ title: String) {
        let backImage = UIImage(named: "ic_back")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage

        self.navigationItem.title = title
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.7254901961, green: 0.2156862745, blue: 0.3764705882, alpha: 1)
    }
    
    func menuButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 20).isActive = true

        return menuBarItem
    }
}

extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}
