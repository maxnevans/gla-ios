//
//  Game.swift
//  ComputerGamesList
//
//  Created by maxnevans on 3/11/20.
//  Copyright © 2020 maxnevans. All rights reserved.
//

import Foundation
import UIKit


struct Game: Codable {
    var name: String = ""
    var rating: Double = 0
    var countPlayers: Int = 0
    var cost: Double = 0
    var trailer: String? = nil
    var logo: String? = nil
    var description: String? = nil
}
