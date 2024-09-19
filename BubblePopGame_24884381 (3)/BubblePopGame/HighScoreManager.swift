//
//  HighScoreManager.swift
//  BubblepopGame
//
//  Created by Yeanhee Park 
//

import Foundation

class HighScoreManager {
    static let shared = HighScoreManager() // Singleton instance
    
    private var highScores: [HighScore] = []
    
    private init() {
        loadHighScores()
    }
    
    func addHighScore(playerName: String, score: Int) {
        let newHighScore = HighScore(playerName: playerName, score: score, date: Date())
        highScores.append(newHighScore)
        highScores.sort { $0.score > $1.score } // Sort scores in descending order
        saveHighScores()
    }
    
    func getHighScores() -> [HighScore] {
        return highScores
    }
    
    private func loadHighScores() {
        if let data = UserDefaults.standard.data(forKey: "highScores") {
            let decoder = JSONDecoder()
            if let savedHighScores = try? decoder.decode([HighScore].self, from: data) {
                highScores = savedHighScores
            }
        }
    }
    
    private func saveHighScores() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(highScores) {
            UserDefaults.standard.set(encoded, forKey: "highScores")
        }
    }
}

struct HighScore: Codable, Identifiable {
    var id = UUID() // Add a property to uniquely identify each HighScore instance
    var playerName: String
    var score: Int
    var date: Date
}
