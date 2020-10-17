//
//  GameTableViewCell.swift
//  Dicoding - RAWG
//
//  Created by Amirul Nizam Alfian on 23/09/20.
//  Copyright © 2020 Amirul Nizam Alfian. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    private var alertDelegate: AlertDelegate?

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var imgBookmark: UIImageView!
    private var isBookmarked: Bool? = nil
    var gameItem: GameItem? = nil
    
    private lazy var gameProvider: GameProvider = { return GameProvider() }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func awakeFromNib() {
        imgBookmark.isUserInteractionEnabled = true
        imgBookmark.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
    }
    
    func setData(_ gameItem: GameItem, alertDelegate: AlertDelegate) {
        self.gameItem = gameItem
        setBookmarkState(gameId: gameItem.id)
        self.name.text = gameItem.name
        self.rating.text = String(format: "%.2f", gameItem.rating)
        self.releaseDate.text = gameItem.releaseDate
        self.img.loadImage(url: gameItem.imgUrl)
        
        self.alertDelegate = alertDelegate
    }
    
    private func setBookmarkState(gameId: Int) {
        self.gameProvider.getGameBookmarkState(gameId) { (bookmarked) in
            DispatchQueue.main.async {
                self.setBookmarkIcon(bookmarked: bookmarked)
            }
        }
    }
    
    private func setBookmarkIcon(bookmarked: Bool) {
        if bookmarked {
            self.imgBookmark.image = UIImage(named: "ic_bookmarked")
        } else {
            self.imgBookmark.image = UIImage(named: "ic_unbookmarked")
        }
        self.isBookmarked = bookmarked
    }
    
    @objc func onBookmarkClicked() {
        if let game = self.gameItem {
            if let bookmarked = self.isBookmarked {
                if bookmarked {
                    self.alertDelegate?.showAlert(message: "Are you sure want to unbookmark this game?", positiveConfirmation: "Yes", negativeConfirmation: "Cancel") {
                        self.gameProvider.deleteGame(game.id) {
                            DispatchQueue.main.async {
                                self.setBookmarkIcon(bookmarked: false)
                                self.alertDelegate?.showToast(message: "Unbookmarked!")
                            }
                        }
                    }
                } else {
                    self.gameProvider.createGame(game.id, game.imgUrl, game.name, game.rating, game.releaseDate) {
                        DispatchQueue.main.async {
                            self.setBookmarkIcon(bookmarked: true)
                            self.alertDelegate?.showToast(message: "Bookmarked!")
                        }
                    }
                }
            }
        }
    }
    
}
