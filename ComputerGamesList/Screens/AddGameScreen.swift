//
//  AddGameScreenViewController.swift
//  ComputerGamesList
//
//  Created by maxnevans on 4/29/20.
//  Copyright © 2020 maxnevans. All rights reserved.
//

import UIKit

class AddGameScreen: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ratingField: UITextField!
    @IBOutlet weak var costField: UITextField!
    @IBOutlet weak var countPlayersField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var addGameButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var model: ModelController!
    var delegate: AddGameScreenDelegate!
    var game: Game!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        game = Game()
        setupElementValues()
        setupElementLocales()
        setupElementAppearance()
    }
    
    private func setupElementValues() {
        nameField.text = ""
        ratingField.text = ""
        costField.text = ""
        countPlayersField.text = ""
        descriptionField.text = ""
    }
    
    private func setupElementLocales() {
        let lang = model.settings.list.language
        
        nameField.placeholder = "Name".localize(lang)
        ratingField.placeholder = "Rating".localize(lang)
        costField.placeholder = "Cost".localize(lang)
        countPlayersField.placeholder = "Count players".localize(lang)
        descriptionField.text = "Description".localize(lang)
        descriptionField.textColor = UIColor.lightGray
        
        addGameButton.setTitle("Add".localize(lang), for: .normal)
        cancelButton.setTitle("Cancel".localize(lang), for: .normal)
    }
    
    private func setupElementAppearance() {
        nameField.font = model.createFont(size: 17)
        ratingField.font = model.createFont(size: 17)
        costField.font = model.createFont(size: 17)
        countPlayersField.font = model.createFont(size: 17)
        descriptionField.font = model.createFont(size: 17)
        
        addGameButton.titleLabel?.font = model.createFont(size: 17)
        cancelButton.titleLabel?.font = model.createFont(size: 17)
    }
    
    @IBAction func addGameClicked(_ sender: Any) {
        game.name = nameField.text ?? ""
        game.cost = Double(costField.text ?? "0") ?? 0
        game.countPlayers = Int(countPlayersField.text ?? "0") ?? 0
        game.rating = Double(ratingField.text ?? "0") ?? 0
        game.description = descriptionField.text
        
        model.games.addGame(game: game)
        navigationController?.popViewController(animated: true)
        delegate?.didAddGame(game: game)
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

protocol AddGameScreenDelegate {
    func didAddGame(game: Game)
}
