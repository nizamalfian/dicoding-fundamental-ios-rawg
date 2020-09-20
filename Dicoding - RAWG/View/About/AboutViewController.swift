//
//  AboutViewController.swift
//  Dicoding - RAWG
//
//  Created by Amirul Nizam Alfian on 20/09/20.
//  Copyright © 2020 Amirul Nizam Alfian. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    private let name = "Amirul Nizam Alfian"
    private let birthday = "27 September 1994"
    private let email = "amirulnizamalfian@gmail.com"

    
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtBirthday: UILabel!
    @IBOutlet weak var txtEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 18)!]
        setBackButton()
        setData()
    }

    private func setBackButton() {
        let backImage = UIImage(named: "ic_back")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.title = "About Me"
//        self.navigationController?.navigationBar.back = [.foregroundColor: UIColor(hex: "#B93760")!]
    }
    
    private func setData() {
        txtName.text = name
        txtBirthday.text = birthday
        txtEmail.text = email
    }

}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
