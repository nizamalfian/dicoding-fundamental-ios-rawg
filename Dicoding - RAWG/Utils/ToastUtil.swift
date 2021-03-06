//
//  ToastUtil.swift
//  Dicoding - RAWG
//
//  Created by Amirul Nizam Alfian on 17/10/20.
//  Copyright © 2020 Amirul Nizam Alfian. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController : AlertDelegate {

    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width / 2 - 75, y: self.view.frame.size.height - 100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "Poppins-Bold", size: 12)!
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showAlert(message: String, positiveConfirmation: String, negativeConfirmation: String, onConfirmedAction: @escaping() -> ()) {
        let confirmedAction = UIAlertAction(title: positiveConfirmation, style: .default) { (action) in
            onConfirmedAction()
        }
        let declinedAction = UIAlertAction(title: negativeConfirmation, style: .cancel, handler: nil)
        let alert = UIAlertController(title: "Warning!", message: message, preferredStyle: .alert)
        alert.addAction(confirmedAction)
        alert.addAction(declinedAction)
        self.present(alert, animated: true)
    }
}

protocol AlertDelegate {
    func showToast(message: String)
    func showAlert(message: String, positiveConfirmation: String, negativeConfirmation: String, onConfirmedAction: @escaping() -> ())
}
