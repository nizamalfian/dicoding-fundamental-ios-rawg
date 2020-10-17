//
//  GameTableViewCell.swift
//  Dicoding - RAWG
//
//  Created by Amirul Nizam Alfian on 23/09/20.
//  Copyright © 2020 Amirul Nizam Alfian. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var imgBookmark: UIImageView!
    private var isBookmarked: Bool? = nil
    private var gameItem: GameItem? = nil
    
    private lazy var gameProvider: GameProvider = { return GameProvider() }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ gameItem: GameItem) {
        self.gameItem = gameItem
        setBookmarkState(gameId: gameItem.id)
        self.name.text = gameItem.name
        self.rating.text = String(format: "%.2f", gameItem.rating)
        self.releaseDate.text = gameItem.releaseDate
        self.img.loadImage(url: gameItem.imgUrl)
        
        // TODO("set bookmark state based on the local database")
        
        imgBookmark.isUserInteractionEnabled = true
        imgBookmark.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
    }
    
    private func setBookmarkState(gameId: Int) {
        self.gameProvider.getGameBookmarkState(gameId) { (bookmarked) in
            print("Game ID -> \(gameId) | bookmarked -> \(bookmarked)")
            self.setBookmarkIcon(bookmarked: bookmarked)
            self.isBookmarked = bookmarked
        }
    }
    
    private func setBookmarkIcon(bookmarked: Bool) {
        if bookmarked {
            self.imgBookmark.image = UIImage(named: "ic_bookmarked")
        } else {
            self.imgBookmark.image = UIImage(named: "ic_unbookmarked")
        }
    }
    
    @objc func onBookmarkClicked() {
        if let game = self.gameItem {
            print("Game ID -> \(game.id) | game name -> \(game.name)")
            if let bookmarked = self.isBookmarked {
                print("Game ID -> \(game.id) | bookmarked -> \(bookmarked)")
                if bookmarked {
                    self.gameProvider.deleteGame(game.id) {
                        self.setBookmarkIcon(bookmarked: false)
                        self.showToast(message: "Unbookmarked!")
                    }
                } else {
                    self.gameProvider.createGame(game.id, game.imgUrl, game.name, game.rating, game.releaseDate) {
                        self.setBookmarkIcon(bookmarked: true)
                        self.showToast(message: "Bookmarked!")
                    }
                }
            }
        }
    }
    
}
