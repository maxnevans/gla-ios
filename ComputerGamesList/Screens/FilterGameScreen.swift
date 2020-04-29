//
//  FilterGameListScreen.swift
//  ComputerGamesList
//
//  Created by maxnevans on 3/12/20.
//  Copyright © 2020 maxnevans. All rights reserved.
//

import UIKit

class FilterGameListScreen: UIViewController {
    
    static let MAX_COST: Double = 10000
    static let MIN_COST: Double = 0
    static let MAX_RATING: Double = 5
    static let MIN_RATING: Double = 0
    static let MAX_PLAYERS_COUNT: Int = 1000000
    static let MIN_PLAYERS_COUNT: Int = 0
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var playersCountLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var minCostSlider: UISlider!
    @IBOutlet weak var maxCostSlider: UISlider!
    @IBOutlet weak var minPlayersCountSlider: UISlider!
    @IBOutlet weak var maxPlayserCountSlider: UISlider!
    @IBOutlet weak var minRatingSlider: UISlider!
    @IBOutlet weak var maxRatingSlider: UISlider!
    
    @IBOutlet weak var playersCountDescLabel: UILabel!
    @IBOutlet weak var costDescLabel: UILabel!
    @IBOutlet weak var ratingDescLabel: UILabel!
    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    var delegate: FilterGameListScreenDelegate?
    var model: ModelController!
    var filters: GameListFilters!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        filters = model.filters.gameList.copy()
        
        //setupElements()
    }
    
    private func setupElements() {
        minCostSlider.minimumValue = Float(GameListFilters.minCost)
        minCostSlider.maximumValue = Float(GameListFilters.maxCost)
        maxCostSlider.minimumValue = Float(GameListFilters.minCost)
        maxCostSlider.maximumValue = Float(GameListFilters.maxCost)
        
        minPlayersCountSlider.minimumValue = Float(GameListFilters.minPlayersCount)
        minPlayersCountSlider.maximumValue = Float(GameListFilters.maxPlayersCount)
        maxPlayserCountSlider.minimumValue = Float(GameListFilters.minPlayersCount)
        maxPlayserCountSlider.maximumValue = Float(GameListFilters.maxPlayersCount)
        
        minRatingSlider.minimumValue = Float(GameListFilters.minRating)
        minRatingSlider.maximumValue = Float(GameListFilters.maxRating)
        maxRatingSlider.minimumValue = Float(GameListFilters.minRating)
        maxRatingSlider.maximumValue = Float(GameListFilters.maxRating)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filters = model.filters.gameList.copy()
        
        setupElementValues()
        setupElementLocales()
        setupElementAppearance()
    }
    
    private func setupElementValues() {
        minCostSlider.value = Float(filters.minCost)
        maxCostSlider.value = Float(filters.maxCost)
        minPlayersCountSlider.value = Float(filters.minCountPlayers)
        maxPlayserCountSlider.value = Float(filters.maxCountPlayers)
        minRatingSlider.value = Float(filters.minRating)
        maxRatingSlider.value = Float(filters.maxRating)
        
        updateRatingField()
        updatePlayersCount()
        updateCostField()
    }
    
    private func setupElementLocales() {
        let lang = model.settings.list.language
        
        costDescLabel.text = "Cost".localize(lang) + ":"
        ratingDescLabel.text = "Rating".localize(lang) + ":"
        playersCountDescLabel.text = "Players count".localize(lang) + ":"
        applyFilterButton.setTitle("Apply Filters".localize(lang), for: .normal)
    }
    
    private func setupElementAppearance() {
        costDescLabel.font = model.createFont(size: 17)
        ratingDescLabel.font = model.createFont(size: 17)
        playersCountDescLabel.font = model.createFont(size: 17)
        applyFilterButton.titleLabel?.font = model.createFont(size: 17)
        costLabel.font = model.createFont(size: 17)
        ratingLabel.font = model.createFont(size: 17)
        playersCountLabel.font = model.createFont(size: 17)
    }
    
    private func updateCostField() {
        let minS = String(format: "%.2f", filters.minCost)
        let maxS = String(format: "%.2f", filters.maxCost)
        
        costLabel.text = minS + " - " + maxS
    }
    
    private func updateRatingField() {
        let minS = String(format: "%.2f", filters.minRating)
        let maxS = String(format: "%.2f", filters.maxRating)
        
        ratingLabel.text = minS + " - " + maxS
    }
    
    private func updatePlayersCount() {
        let minS = String(filters.minCountPlayers)
        let maxS = String(filters.maxCountPlayers)
        
        playersCountLabel.text = minS + " - " + maxS
    }

    @IBAction func changeMinCost(_ sender: Any) {
        let dif = FilterGameListScreen.MAX_COST - FilterGameListScreen.MIN_COST
        filters.minCost = Double(minCostSlider.value) * dif + FilterGameListScreen.MIN_COST
        
        updateCostField()
    }
    
    @IBAction func changeMaxCost(_ sender: Any) {
        let dif = FilterGameListScreen.MAX_COST - FilterGameListScreen.MIN_COST
        filters.maxCost = Double(maxCostSlider.value) * dif + FilterGameListScreen.MIN_COST
        
        updateCostField()
    }
    
    @IBAction func changeMinPlayersCount(_ sender: Any) {
        let dif = FilterGameListScreen.MAX_PLAYERS_COUNT - FilterGameListScreen.MIN_PLAYERS_COUNT
        filters.minCountPlayers = Int((minPlayersCountSlider.value * Float(dif)).rounded()) + FilterGameListScreen.MIN_PLAYERS_COUNT
        updatePlayersCount()
    }
    
    @IBAction func changeMaxPlayersCount(_ sender: Any) {
        let dif = FilterGameListScreen.MAX_PLAYERS_COUNT - FilterGameListScreen.MIN_PLAYERS_COUNT
        filters.maxCountPlayers = Int((maxPlayserCountSlider.value * Float(dif)).rounded()) + FilterGameListScreen.MIN_PLAYERS_COUNT
        updatePlayersCount()
    }
    
    @IBAction func changeMinRating(_ sender: Any) {
        let dif = FilterGameListScreen.MAX_RATING - FilterGameListScreen.MIN_RATING
        filters.minRating = Double(minRatingSlider.value) * dif + FilterGameListScreen.MIN_RATING
        updateRatingField()
    }
    
    @IBAction func changeMaxRating(_ sender: Any) {
        let dif = FilterGameListScreen.MAX_RATING - FilterGameListScreen.MIN_RATING
        filters.maxRating = Double(maxRatingSlider.value) * dif + FilterGameListScreen.MIN_RATING
        updateRatingField()
    }
    
    
    @IBAction func applyFiltersPressed(_ sender: Any) {
        model.filters.gameList = filters
        navigationController?.popViewController(animated: true)
        delegate?.didApplyFilters(filters: filters)
    }
}

protocol FilterGameListScreenDelegate {
    func didApplyFilters(filters: GameListFilters)
}
