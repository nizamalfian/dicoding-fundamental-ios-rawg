//
//  ImageUtils.swift
//  Dicoding - RAWG
//
//  Created by Amirul Nizam Alfian on 17/10/20.
//  Copyright © 2020 Amirul Nizam Alfian. All rights reserved.
//

import Foundation
import UIKit

func imageToData(_ title: String) -> Data?{
    guard let img = UIImage(named: title) else { return nil }
    return img.jpegData(compressionQuality: 1)
}
