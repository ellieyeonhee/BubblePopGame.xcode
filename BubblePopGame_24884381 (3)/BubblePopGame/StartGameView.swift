//
//  StartGameView.swift
//  BubblepopGame
//
//   Created by Yeanhee Park
//

import SwiftUI

struct StartGameView: View {
    @ObservedObject var bubbleViewModel = BubbleViewModel()
    @State private var showingHighScoreView = false


    var body: some View {
        NavigationView {
            VStack {
                Text("Score: \(bubbleViewModel.score)")
                    .font(.title)
                Text("Time Left: \(Int(bubbleViewModel.gameTime))")
                    .font(.title)

                ZStack {
                    ForEach(bubbleViewModel.bubbles.indices, id: \.self) { index in
                        let bubble = bubbleViewModel.bubbles[index] // Access the bubble at the current index
                        BubbleView(color: bubble.color)
                            .position(bubble.position.point)
                            .onTapGesture {
                                bubbleViewModel.popBubble(at: index)
                            }
                    }
                  }

                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
            }
            .onAppear {
                bubbleViewModel.startTimer()
            }
            .onChange(of: bubbleViewModel.gameTime) { newTime in
                if newTime == 0 {
                    showingHighScoreView = true
                }
            }
            .alert(isPresented: $showingHighScoreView) {
                Alert(
                    title: Text("Game Over"),
                    message: Text("Your game is over!"),
                    primaryButton: .default(Text("OK")) {
                     
                        // Handle navigation to HighScoreView
                        
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct BubbleView: View {
         var color: Color
         
         var body: some View {
             ZStack {
                 Circle()
                     .fill(color)
                     .frame(width: 70, height: 70)
                     .overlay(Circle().stroke(Color.white, lineWidth: 2))
                     .shadow(color: .black, radius: 5, x: 0, y: 5)
                 
                 Circle()
                     .fill(LinearGradient(gradient: Gradient(colors: [color.opacity(0.5), color.opacity(0)]), startPoint: .top, endPoint: .bottom))
                     .frame(width: 70, height: 70)
                     .mask(Circle().padding(5))
             }
         }
     }

#Preview {
    StartGameView()
}
