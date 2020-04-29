//
//  GameDetailScreen.swift
//  ComputerGamesList
//
//  Created by maxnevans on 3/12/20.
//  Copyright © 2020 maxnevans. All rights reserved.
//

import UIKit
import AVKit

class GameDetailsScreen: UIViewController {
    
    @IBOutlet weak var logoValueImage: UIImageView!
    @IBOutlet weak var nameValueLabel: UILabel!
   
    @IBOutlet weak var descriptionValueLabel: UITextView!
    @IBOutlet weak var costValueLabel: UILabel!
    @IBOutlet weak var countPlayersValueLabel: UILabel!
    @IBOutlet weak var ratingValueLabel: UILabel!
    @IBOutlet weak var watchTrailerLabel: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var countPlayersLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    var game: Game?
    var model: ModelController!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupElementsValue()
        setupElementsLocale()
        setupElementsAppearance()
    }
    
    private func setupElementsValue() {
        if let cost = game?.cost {
            if (cost == 0) {
                costValueLabel.text = "free to play".localize(model.settings.list.language)
            } else {
                costValueLabel.text = String(cost)
            }
        }
        
        nameValueLabel.text = game?.name ?? "unknown".localize(model.settings.list.language)
        ratingValueLabel.text = String(game?.rating ?? 0)
        countPlayersValueLabel.text = String(game?.countPlayers ?? 0)
        descriptionValueLabel.text = game?.description ?? ""
        model.games.resolveImage(game?.logo) { image in
            self.logoValueImage.image = image
        }
    }
    
    private func setupElementsLocale() {
        let lang = model.settings.list.language
        watchTrailerLabel.setTitle("Watch trailer".localize(lang), for: .normal)
        infoLabel.text = "Info".localize(lang) + ":"
        costLabel.text = "Cost".localize(lang) + ":"
        countPlayersLabel.text = "Count Players".localize(lang) + ":"
        ratingLabel.text = "Rating".localize(lang) + ":"
    }
    
    private func setupElementsAppearance() {
        watchTrailerLabel.titleLabel?.font = model.createFont(size: 15)
        infoLabel.font = model.createFont(size: 17)
        countPlayersLabel.font = model.createFont(size: 17)
        ratingLabel.font = model.createFont(size: 17)
        costLabel.font = model.createFont(size: 17)
        nameValueLabel.font = model.createFont(size: 23)
        countPlayersValueLabel.font = model.createFont(size: 17)
        ratingValueLabel.font = model.createFont(size: 17)
        costValueLabel.font = model.createFont(size: 17)
        descriptionValueLabel.font = model.createFont(size: 17)
    }
    
    @IBAction func watchTrailerButtonPressed(_ sender: Any) {
        if (game?.trailer == nil) {
            createVideoErrorAlert(filename: "<nil>")
            return
        }
        
        model.games.resolveVideo(game?.trailer) { url in
            guard let url = url else {
                debugPrint("\(self.game?.trailer ?? "<nil>") not found")
                
                self.createVideoErrorAlert(filename: self.game?.trailer ?? "unknown".localize(self.model.settings.list.language))
                return
            }
            
            let player = AVPlayer(url: url)
            
            let playerController = AVPlayerViewController()
            playerController.player = player
            
            self.present(playerController, animated: true) {
                player.play()
            }
        }
    }
    
    func createVideoErrorAlert(filename: String) {
        let lang = model.settings.list.language
        let ct = UIAlertController(title: "Error: Trailer could not be loaded".localize(lang), message: "Failed to load trailer".localize(lang), preferredStyle: .alert );
        
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        ct.addAction(action)
        
        present(ct, animated: true, completion: nil)
    }
}
