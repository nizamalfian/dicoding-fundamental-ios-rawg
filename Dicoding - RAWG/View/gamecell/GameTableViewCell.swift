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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ gameItem: GameItem) {
        self.name.text = gameItem.name
        self.rating.text = String(format: "%.2f", gameItem.rating)
        self.releaseDate.text = gameItem.releaseDate
        self.img.loadImage(url: gameItem.imgUrl)
        
        // TODO("set bookmark state based on the local database")
        
        imgBookmark.isUserInteractionEnabled = true
        imgBookmark.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBookmarkClicked)))
    }
    
    @objc func onBookmarkClicked() {
        print("Bookmark clicked!!!")
    }
    
}
