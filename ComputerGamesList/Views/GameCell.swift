//
//  GameCell.swift
//  ComputerGamesList
//
//  Created by maxnevans on 3/11/20.
//  Copyright © 2020 maxnevans. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var playersLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!

    
    func setupElementAppearance(model: ModelController) {
        nameLabel.font = model.createFont(size: 14)
        ratingLabel.font = model.createFont(size: 14)
        playersLabel.font = model.createFont(size: 14)
        costLabel.font = model.createFont(size: 14)
    }
    
    func setGame(model: ModelController, game: Game) {
        let lang = model.settings.list.language
        model.games.resolveImage(game.logo) { image in
            self.logoImage.image = image
        }
        nameLabel.text = game.name
        ratingLabel.text = "Rating".localize(lang) + ": \(game.rating) " + "of".localize(lang) + " 5"
        playersLabel.text = "Players".localize(lang) + ": \(game.countPlayers)"
        
        var costAmount: String
        if (game.cost == 0) {
            costAmount = "free to play".localize(lang)
        } else {
            costAmount = "\(game.cost)$"
        }
        
        costLabel.text = "Cost".localize(lang) + ": \(costAmount)"
    }
}
