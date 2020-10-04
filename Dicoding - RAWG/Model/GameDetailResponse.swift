//
//  GameDetailResponse.swift
//  Dicoding - RAWG
//
//  Created by Amirul Nizam Alfian on 04/10/20.
//  Copyright © 2020 Amirul Nizam Alfian. All rights reserved.
//

import Foundation
import UIKit

struct GameDetailResponse: Codable {
    let website: String
    let description: String
    let genres: [Genre]
    let publishers: [Publisher]
    
    enum CodingKeys: String, CodingKey {
        case website
        case description = "description_raw"
        case genres
        case publishers
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        website = try container.decode(String.self, forKey: .website)
        description = try container.decode(String.self, forKey: .description)
        genres = try container.decode([Genre].self, forKey: .genres)
        publishers = try container.decode([Publisher].self, forKey: .publishers)
    }
}
