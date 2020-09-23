//
//  DetailViewController.swift
//  Dicoding - RAWG
//
//  Created by Amirul Nizam Alfian on 23/09/20.
//  Copyright © 2020 Amirul Nizam Alfian. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var gameName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
    }

    private func setBackButton() {
        let backImage = UIImage(named: "ic_back")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        if let title = gameName {
            self.navigationItem.title = title
        }
        
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 0.7254901961, green: 0.2156862745, blue: 0.3764705882, alpha: 1)
    }

}
