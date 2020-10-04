//
//  Genre.swift
//  Dicoding - RAWG
//
//  Created by Amirul Nizam Alfian on 04/10/20.
//  Copyright © 2020 Amirul Nizam Alfian. All rights reserved.
//

import Foundation
import UIKit

struct Genre: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }
}
