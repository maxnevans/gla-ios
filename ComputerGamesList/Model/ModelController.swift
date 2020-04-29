//
//  ModelController.swift
//  ComputerGamesList
//
//  Created by maxnevans on 3/14/20.
//  Copyright © 2020 maxnevans. All rights reserved.
//

import Foundation
import UIKit

class ModelController {
    
    private let gamesController: GamesStorageController
    private let settingsController: SettingsStorageController
    private let filtersController: FiltersStorageController
    
    var games: GamesStorageController {
        get {
            return gamesController
        }
    }
    
    var settings: SettingsStorageController {
        get {
            return settingsController
        }
    }
    var filters: FiltersStorageController {
        get {
            return filtersController
        }
    }

    
    init() {
        gamesController = GamesStorageController()
        settingsController = SettingsStorageController()
        filtersController = FiltersStorageController()
    }
    
    var filteredGames: [Game] {
        return games.list.filter { game in
            if (game.cost < filters.gameList.minCost) {
                return false
            }
            
            if game.cost > filters.gameList.maxCost {
                return false
            }
            
            if (game.rating < filters.gameList.minRating) {
                return false
            }
            
            if game.rating > filters.gameList.maxRating {
                return false
            }
            
            if game.countPlayers < filters.gameList.minCountPlayers {
                return false
            }
            
            if game.countPlayers > filters.gameList.maxCountPlayers {
                return false
            }
            
            return true
        }
    }
    
    func createFont(size: Float) -> UIFont {
        return settings.list.font.withSize(CGFloat(size * settings.list.fontSizeFactor))
    }
}
