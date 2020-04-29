//
//  GameListScreen.swift
//  ComputerGamesList
//
//  Created by maxnevans on 3/11/20.
//  Copyright © 2020 maxnevans. All rights reserved.
//

import UIKit

class GameListScreen: UIViewController {
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    
    var model: ModelController!
    var games: [Game]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.games.loadGames{
            self.games = self.model.filteredGames
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        games = model.filteredGames
        
        setupElementsLocales()
        setupElementsAppearence()
        tableView.reloadData()
    }
    
    private func setupElementsLocales() {
        settingsButton.title = "Settings".localize(model.settings.list.language)
        navBar.title = "Game List".localize(model.settings.list.language)
    }
    
    private func setupElementsAppearence() {
        settingsButton.setTitleTextAttributes([NSAttributedString.Key.font: model.createFont(size: 17)], for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GameListToDetail") {
            let destVC = segue.destination as! GameDetailsScreen
            
            destVC.game = sender as? Game
            destVC.model = model
        }
        
        if (segue.identifier == "ShowFilters") {
            let filtersVC = segue.destination as! FilterGameListScreen

            filtersVC.delegate = self
            filtersVC.model = model
        }
        
        if (segue.identifier == "ShowSettings") {
            let settingsVC = segue.destination as! SettingsScreen
            
            settingsVC.delegate = self
            settingsVC.model = model
        }
        
        if (segue.identifier == "ShowAddGame") {
            let addGameVC = segue.destination as! AddGameScreen
            
            addGameVC.delegate = self
            addGameVC.model = model
        }
    }
    
    @IBAction func filterClicked(_ sender: Any) {
        performSegue(withIdentifier: "ShowFilters", sender: nil)
    }
    
    @IBAction func settingsClicked(_ sender: Any) {
        performSegue(withIdentifier: "ShowSettings", sender: nil)
    }
    
    @IBAction func addGameClicked(_ sender: Any) {
        performSegue(withIdentifier: "ShowAddGame", sender: nil)
    }
    
}

extension GameListScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell") as! GameCell
        
        cell.setupElementAppearance(model: model)
        cell.setGame(model: model, game: games[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = games[indexPath.row]
        
        performSegue(withIdentifier: "GameListToDetail", sender: game)
    }
}

extension GameListScreen: SettingsScreenDelegate, FilterGameListScreenDelegate, AddGameScreenDelegate {
    func didApplySettings(settings: Settings) {
        tableView.reloadData()
    }
    
    func didApplyFilters(filters: GameListFilters) {
        tableView.reloadData()
    }
    
    func didAddGame(game: Game) {
        tableView.reloadData()
    }
}
