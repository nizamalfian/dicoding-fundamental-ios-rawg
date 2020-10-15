//
//  GameItem.swift
//  Dicoding - RAWG
//
//  Created by Amirul Nizam Alfian on 23/09/20.
//  Copyright © 2020 Amirul Nizam Alfian. All rights reserved.
//

import Foundation
import UIKit

struct GameItem: Codable {
    let id: Int
    let imgUrl: String
    let name: String
    let rating: Double
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case imgUrl = "background_image"
        case name
        case rating
        case releaseDate = "released"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        imgUrl = try container.decode(String.self, forKey: .imgUrl)
        name = try container.decode(String.self, forKey: .name)
        rating = try container.decode(Double.self, forKey: .rating)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
    }
    
    init(id: Int, imgUrl: String, name: String, rating: Double, releaseDate: String) {
        self.id = id
        self.imgUrl = imgUrl
        self.name = name
        self.rating = rating
        self.releaseDate = releaseDate
    }
}
