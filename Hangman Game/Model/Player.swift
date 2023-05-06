//
//  Player.swift
//  Hangman Game
//
//  Created by Lilian MAGALHAES on 2023-04-05.
//

import Foundation
struct Player: Codable {
    let playerName: String
    let playerEmail: String
    var score: Int = 0
    var numberOfMatches: Int = 0
    }

