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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 18)!]
    }


    @IBAction func onInfoClicked(_ sender: UIBarButtonItem) {
        let about = AboutViewController(nibName: "AboutViewController", bundle: nil)
        self.navigationController?.pushViewController(about, animated: true)
    }
}

