//
//  Filters.swift
//  ComputerGamesList
//
//  Created by maxnevans on 3/12/20.
//  Copyright © 2020 maxnevans. All rights reserved.
//

import Foundation


struct GameListFilters {
    static let minCost: Double = 0
    static let maxCost: Double = 100000
    static let minRating: Double = 0
    static let maxRating: Double = 5
    static let minPlayersCount: Int = 0
    static let maxPlayersCount: Int = 10000000
    
    var maxCost: Double
    var minCost: Double
    var maxRating: Double
    var minRating: Double
    var maxCountPlayers: Int
    var minCountPlayers: Int
    
    init() {
        maxCost = GameListFilters.maxCost
        minCost = GameListFilters.minCost
        maxRating = GameListFilters.maxRating
        minRating = GameListFilters.minRating
        maxCountPlayers = GameListFilters.maxPlayersCount
        minCountPlayers = GameListFilters.minPlayersCount
    }
    
    func copy() -> GameListFilters {
        return self
    }
}
