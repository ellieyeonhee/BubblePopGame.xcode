//
//  BubbleViewModel.swift
//  BubblepopGame
//
//  Created by Yeanhee Park
//

import SwiftUI

struct PointWrapper: Hashable {
    let point: CGPoint
    
    init(_ point: CGPoint) {
        self.point = point
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(point.x)
        hasher.combine(point.y)
    }
    
    static func == (lhs: PointWrapper, rhs: PointWrapper) -> Bool {
        return lhs.point == rhs.point
    }
}

struct Bubble {
    let id = UUID()
    let color: Color
    var position: PointWrapper
}

class BubbleViewModel: ObservableObject {
    @Published var bubbles: [Bubble] = []
    @Published var poppedBubbleIndex: Int?
    @Published var score: Int = 0 // Score property added
    @Published var gameTime: Double = 60 // Default game time
    @Published var maxBubbles: Int = 15 // Default maximum number of bubbles
    
    var highScore: Int {
        UserDefaults.standard.integer(forKey: "highScore")
    }
    
    private var timer: Timer?
    
    init() {
        generateBubbles()
        startTimer()
    }
    
    func startTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if self.gameTime > 0 {
                    
                    self.gameTime -= 1
                } else {
                    self.timer?.invalidate()
                    // Game over logic can be added here
                    self.isGameOver = true
                }
            }
        }
    
    @State private var isGameOver: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                // Your game UI components
                
                NavigationLink(destination: HighScoreView(), isActive: $isGameOver) {
                    EmptyView() // Invisible navigation link
                }
            }
        }
    }
        
    func generateBubbles() {
        bubbles.removeAll()
        
        var bubblePositions: Set<PointWrapper> = Set() // Keep track of occupied positions
        
        let numberOfBubbles = min(Int.random(in: 1...maxBubbles), maxBubbles) // Random number of bubbles between 1 and maxBubbles, limited by maxBubbles
        for _ in 0..<numberOfBubbles {
            var randomPosition = CGPoint(x: CGFloat.random(in: 50...350), y: CGFloat.random(in: 50...750))
            
            // Wrap the CGPoint in PointWrapper
            var pointWrapper = PointWrapper(randomPosition)
            
            // Check if the position is already occupied
            while bubblePositions.contains(pointWrapper) {
                randomPosition = CGPoint(x: CGFloat.random(in: 50...350), y: CGFloat.random(in: 50...750))
                pointWrapper = PointWrapper(randomPosition) // Update the wrapped position
            }
            
            let randomColor = generateRandomColor()
            bubblePositions.insert(pointWrapper)
            
            // Create a Bubble object and append it to the bubbles array
            bubbles.append(Bubble(color: randomColor, position: pointWrapper))
        }
    }

    



    
    func generateRandomColor() -> Color {
        // Generate random color based on the probabilities provided
        let randomNumber = Int.random(in: 1...100)
        if randomNumber <= 40 {
            return .red
        } else if randomNumber <= 70 {
            return .pink
        } else if randomNumber <= 85 {
            return .green
        } else if randomNumber <= 95 {
            return .blue
        } else {
            return .black
        }
        
    }
    
    /*func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.gameTime -= 1
            if self.gameTime <= 0 {
                timer.invalidate()
                // Handle game over logic here
            }
        }
    }*/
    
    /*
    func popBubble(at index: Int) {
        let poppedBubble = bubbles.remove(at: index)
        score += calculateScore(for: poppedBubble.color)
        // Add logic to calculate and store the score after popping the bubble
        
        generateBubbles()
        
    } */
    func popBubble(at index: Int) {
        var poppedBubbles: [Bubble] = []
        
        // Pop the first bubble
        let poppedBubble = bubbles.remove(at: index)
        poppedBubbles.append(poppedBubble)
        
        // Check for consecutive bubbles of the same color and pop them
        var nextIndex = index
        while nextIndex < bubbles.count && bubbles[nextIndex].color == poppedBubble.color {
            let nextPoppedBubble = bubbles.remove(at: nextIndex)
            poppedBubbles.append(nextPoppedBubble)
        }
        
        // Calculate the total score for popped bubbles
        var totalScore = 0
        for bubble in poppedBubbles {
            let bubbleScore = calculateScore(for: bubble.color)
            totalScore += bubbleScore
            
            // Apply bonus points if there are consecutive bubbles
            if poppedBubbles.count > 1 {
                totalScore += Int(Double(bubbleScore) * 0.5) // Add 50% bonus
            }
        }
        
        score += totalScore
        
        generateBubbles()
    }
    
    private func saveHighScore(_ score: Int) {
        UserDefaults.standard.set(score, forKey: "highScore")
    }
    

    
    private func calculateScore(for color: Color) -> Int {
            // Calculate score based on bubble color
            switch color {
            case .red:
                return 1
            case .pink:
                return 2
            case .green:
                return 5
            case .blue:
                return 8
            case .black:
                return 10
            default:
                return 0
            }
        }
    
    func resetGame() {
        bubbles.removeAll()
        poppedBubbleIndex = nil
        score = 0
        gameTime = 60
        generateBubbles()
    }
}
