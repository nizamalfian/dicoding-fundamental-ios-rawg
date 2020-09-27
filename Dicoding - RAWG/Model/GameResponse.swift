//
//  GameResponse.swift
//  Dicoding - RAWG
//
//  Created by Amirul Nizam Alfian on 27/09/20.
//  Copyright © 2020 Amirul Nizam Alfian. All rights reserved.
//

import Foundation

struct GameResponse: Codable {
    let games: [GameItem]
    
    enum CodingKeys: String, CodingKey {
        case games = "results"
    }
}
