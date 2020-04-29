//
//  StorageModelController.swift
//  ComputerGamesList
//
//  Created by maxnevans on 3/14/20.
//  Copyright © 2020 maxnevans. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class GamesStorageController {
    let gamesRef: CollectionReference!
    let filesRef: StorageReference!
    var gamesCached: [Game]
    var isLoaded: Bool
    
    var list: [Game] {
        get {
            return gamesCached;
        }
    }
    
    public init() {
        gamesRef = Firestore.firestore().collection("games")
        filesRef = Storage.storage().reference();
        gamesCached = []
        isLoaded = false
    }
    
    public func loadGames(onLoad: @escaping () -> Void) {
        getGames{ games in
            self.gamesCached = games
            self.isLoaded = true
            onLoad()
        }
    }
    
    private func getGames(_ handleData: @escaping([Game]) -> Void) {
        gamesCached = loadGamesFromLocalFile("games.json")
        
        handleData(gamesCached)
        loadGamesFromDatabase{ games in
            self.gamesCached = games
            handleData(self.gamesCached)
        }
    }
    
    public func addGame(game: Game) {
        gamesCached.append(game)
        saveGamesToDatabase([game])
        saveGamesToLocalFile(fileName: "games.json", games: gamesCached)
    }
    
    public func saveGames(_ games: [Game]) {
        saveGamesToDatabase(games)
    }
    
    private func loadGamesFromDatabase(handleData: @escaping ([Game]) -> Void) {
        gamesRef.getDocuments { (snapshot, error) in
            if let err = error {
                print("Failed to load documents from db: \(err)")
                return
            }
            
            var games = [Game]()
            for document in snapshot!.documents {
                let game = document.data()
                var g: Game = Game()
                g.name = game["name"] as? String ?? ""
                g.description = game["description"] as? String
                g.cost = game["cost"] as? Double ?? 0
                g.rating = game["rating"] as? Double ?? 0
                g.logo = game["logo"] as? String
                g.trailer = game["trailer"] as? String
                g.countPlayers = game["countPlayers"] as? Int ?? 0
                games.append(g)
            }
            
            handleData(games)
        }
    }
    
    private func saveGamesToDatabase(_ games: [Game]) {
        for game in games {
            gamesRef.document().setData([
                "name" : game.name,
                "logo" : game.logo ?? "",
                "rating" : game.rating,
                "countPlayers" : game.countPlayers,
                "cost" : game.cost,
                "trailer" : game.trailer ?? "",
                "description" : game.description ?? ""
            ]) {err in
                if let err = err {
                    print("Failed to write document to db: \(err)")
                }
            }
        }
    }
    
    private func loadGamesFromResourceFile(_ resFileName: String) -> [Game] {
        guard let filePath = Bundle.main.url(forResource: resFileName, withExtension: "json") else {
            return []
        }

        do {
            let data = try Data(contentsOf: filePath)
            let dec = JSONDecoder()
            return try dec.decode([Game].self, from: data)
        } catch {
            print("Failed to load from resource file!")
            return []
        }
    }
    
    private func loadGamesFromLocalFile(_ fileName: String) -> [Game] {
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        
        do {
            let data = try Data(contentsOf: filePath)
            let dec = JSONDecoder()
            return try dec.decode([Game].self, from: data)
        } catch {
            print("Failed to load from local file!")
            return []
        }
    }
    
    private func saveGamesToLocalFile(fileName: String, games: [Game]) {
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        
        do {
            let enc = JSONEncoder()
            enc.outputFormatting = .prettyPrinted
            try enc.encode(games).write(to: filePath)
        } catch {
            print("Failed to write data in " + fileName)
        }
    }
    
    // Resolves game.trailer trailer by filename from any available source
    public func resolveVideo(_ filename: String?, _ handleVideo: @escaping (URL?) -> Void) {
        // If name is not provided do nothing
        guard let filename = filename, filename.count > 0 else {
            handleVideo(nil)
            print("Failed to load trailer: filename is nil")
            return
        }
        
        // Try to load from local storage
        if let _ = loadFileFromLocalFile(filename) {
            handleVideo(createLocalFileUrl(filename))
            print("Success on load trailer from local storage: \"\(filename)\"")
            return
        }
        
        // Try to load from database if there is no in local storage
        loadFileFromDatabase(filename) { data in
            if let data = data {
                // Cache trailer to local storage
                self.saveFileToLocalFile(filename, data)
                print("Success on load trailer from database: \"\(filename)\"; Return local url")
                handleVideo(self.createLocalFileUrl(filename))
                return
            } else {
                print("Failed to load video from database: \(filename); Try to return url from database...")
                self.createDatabaseFileUrl(filename) { url in
                    guard let url = url else {
                        print("Failed to create url to video: \"\(filename)\"")
                        handleVideo(nil)
                        return
                    }
                    handleVideo(url)
                    print("Success on create remote url to video: \"\(filename)\"")
                }
            }
        }
    }
    
    // Resolves game.logo image by filename from any available source
    public func resolveImage(_ filename: String?, _ handleImage: @escaping (UIImage?) -> Void) {
        let defaultLogoFilename = "default_logo.jpg"
        
        // If name is not provided load default file from resources
        guard let filename = filename, filename.count > 0 else {
            if let data = loadFileFromResourceFile(defaultLogoFilename) {
                print("Success on load \(defaultLogoFilename) from resource without filename")
                handleImage(UIImage(data: data))
                return
            } else {
                print("Failed to load \(defaultLogoFilename) from resource when resolve image!")
                return
            }
        }
        
        // First load from local file
        if let data = loadFileFromLocalFile(filename) {
            handleImage(UIImage(data: data))
            print("Success on load image from local storage: \"\(filename)\"")
            return
        }
        
        // Second start loading from database if there is no in local storage
        loadFileFromDatabase(filename) { data in
            if let data = data {
                // Cache image in local storage
                self.saveFileToLocalFile(filename, data)
                handleImage(UIImage(data: data))
                print("Success on load image from database: \"\(filename)\"")
            } else {
                print("Failed to load image from database!")
            }
        }
        
        // If has no image in local storage and while downloading from database load default from resources
        if let data = loadFileFromResourceFile(defaultLogoFilename) {
            handleImage(UIImage(data: data))
            print("Success on load image from resource: \"\(defaultLogoFilename)\" instead of \"\(filename)\"")
            return
        }
        
        handleImage(nil)
        print("Failed to load image \"\(filename)\" completely!")
    }
    
    // Saves file to local storage by name
    private func saveFileToLocalFile(_ filename: String, _ data: Data) {
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        
        do {
            try data.write(to: filePath)
        } catch let err {
            print("Failed to write file to local storage! Error: \(err.localizedDescription)")
        }
    }
    
    // Loads file from local storage by name or returns nil if file does not exist
    private func loadFileFromLocalFile(_ filename: String) -> Data? {
        let filePath = createLocalFileUrl(filename)
        return try? Data(contentsOf: filePath)
    }
    
    // Loads file from resource by namy or returns nil if file does not exist
    private func loadFileFromResourceFile(_ filename: String) -> Data? {
        guard let filePath = Bundle.main.url(forResource: filename, withExtension: "") else {
            return nil
        }
        
        return try? Data(contentsOf: filePath)
    }
    
    // Loads file from database by name or returns nil if file does not exist
    private func loadFileFromDatabase(_ filename: String, _ handleData: @escaping (Data?) -> Void) {
        filesRef.child(filename).getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let err = error {
                print("Failed to load file \"\(filename)\" from database: \(err)")
                handleData(nil)
                return
            }
            
            handleData(data)
        }
    }
    
    private func createDatabaseFileUrl(_ filename: String, _ handleUrl: @escaping (URL?) -> Void) {
        filesRef.child(filename).downloadURL{ url, err in
            if let err = err {
                print("Failed to create download file url for \"\(filename)\": \(err)")
                handleUrl(nil)
                return
            }
            handleUrl(url)
        }
    }
    
    private func createLocalFileUrl(_ filename: String) -> URL {
         return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
    }
}
