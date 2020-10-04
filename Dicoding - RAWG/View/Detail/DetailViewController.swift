//
//  DetailViewController.swift
//  Dicoding - RAWG
//
//  Created by Amirul Nizam Alfian on 23/09/20.
//  Copyright © 2020 Amirul Nizam Alfian. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var gameItem: GameItem?
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var publishers: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        loadData()
    }

    private func setBackButton() {
        let backImage = UIImage(named: "ic_back")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        if let game = gameItem {
            self.navigationItem.title = game.name
            self.img.loadImage(url: game.imgUrl)
            self.rating.text = String(format: "%.2f", game.rating)
            self.releaseDate.text = game.releaseDate
        }
        
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 0.7254901961, green: 0.2156862745, blue: 0.3764705882, alpha: 1)
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
        let decoder = JSONDecoder()
        let gameDetailResponse = try! decoder.decode(GameDetailResponse.self, from: data)
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
        }
    }

}
