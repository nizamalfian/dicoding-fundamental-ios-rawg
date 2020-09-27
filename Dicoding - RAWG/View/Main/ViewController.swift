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
    
    var games = [GameItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 18)!]
        
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
    
    private func decodeJson(data: Data) {
        let decoder = JSONDecoder()
        let gameResponse = try! decoder.decode(GameResponse.self, from: data)
        self.games = gameResponse.games
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
