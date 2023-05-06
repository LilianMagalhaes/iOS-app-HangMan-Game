//
//  GameStats.swift
//  Hangman Game
//
//  Created by Lilian MAGALHAES on 2023-04-06.
//

import Foundation
class GameStats{
    static var shared = GameStats()
    var playersArray : [Player] = []
    private init() {}
    private let  userDefaults = UserDefaults.standard
    
    var totalMatchesPlayed: Int?{
        get {
            return userDefaults.integer(forKey: "totalMatchesPlayed")
        }
        set {
            userDefaults.set(newValue, forKey: "totalMatchesPlayed")
            userDefaults.synchronize()
        }
    }
    
    func save(player: Player) {
        let isPlayerExists = playersArray.contains(where: { searchedPlayer in
            return searchedPlayer.playerEmail == player.playerEmail
        })
        if  !isPlayerExists {
            playersArray.append(player)
            savePlayers()
        }
    }
    
    private func savePlayers() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(playersArray)
            UserDefaults.standard.set(data, forKey: "players")
            UserDefaults.standard.synchronize()
        } catch {
            print("error")
        }
    }
    
    func getPlayers()  -> [Player] {
        if let playersData = UserDefaults.standard.value(forKey: "players") as? Data {
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode([Player].self, from: playersData) {
                playersArray = objectsDecoded
                return playersArray
            } else {
                return []
            }
        }
        return []
    }
    
    func getPlayerBy(name: String)  -> Player?  {
        return playersArray.first { player in
            return player.playerName == name
        }
    }
        
        func sortPlayersByScore() -> [Player] {
            let sortedPlayersData = playersArray.sorted(by: { $0.score > $1.score })
            let TopPlayersArray = Array(sortedPlayersData .prefix(5))
            return TopPlayersArray
        }
    
        func getTopPlayer(index: Int?, topFiveArray: [Player]?) -> Player? {
            if let playerIndex = index, let topPlayersArray = topFiveArray, playerIndex < topPlayersArray.count {
                let topPlayer = topPlayersArray[playerIndex]
                return topPlayer
            }
            return nil
        }
    
}
