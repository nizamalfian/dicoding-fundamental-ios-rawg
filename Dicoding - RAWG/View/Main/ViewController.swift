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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 18)!]
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
    }

    @IBAction func onInfoClicked(_ sender: UIBarButtonItem) {
        let about = AboutViewController(nibName: "AboutViewController", bundle: nil)
        self.navigationController?.pushViewController(about, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell {
            let gameItem = games[indexPath.row]
            cell.name.text = gameItem.name
            cell.rating.text = String(format: "%.2f", gameItem.rating)
            cell.releaseDate.text = gameItem.releaseDate
            cell.img.loadImage(url: gameItem.imgUrl)
            
            return cell
        } else {
            return UITableViewCell()
        }
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
