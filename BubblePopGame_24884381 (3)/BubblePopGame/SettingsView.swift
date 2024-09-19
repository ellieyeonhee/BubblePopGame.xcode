//
//  SettingsView.swift
//  BubblepopGame
//
//   Created by Yeanhee Park
//

import SwiftUI

struct SettingsView: View {
    @StateObject var highScoreViewModel = HighScoreViewModel()
    @State private var countdownInput = ""
    @State private var countdownValue: Double = 0
    @State var numberOfBubbles: Double = 0
    @State private var isStartButtonEnabled: Bool = false
    @State private var isStartGameActive: Bool = false
    
    var body: some View {
            VStack{
                Label("Settings", systemImage: "")
                    .foregroundStyle(.green)
                    .font(.title)
                    Spacer()
                Text("Enter Your Name:")
                
                TextField("Enter Name", text: $highScoreViewModel.taskDescription)
                    .padding()
                    Spacer()
                Text("Game Time")
                Slider(value: $countdownValue, in: 0...60, step: 1)
                    .padding()
                    .onChange(of: countdownValue, perform: { value in
                        countdownInput = "\(Int(value))"
                    })
                Text(" \(Int(countdownValue))")
                    .padding()

                Text("Max Number of Bubbles")
                Slider(value: $numberOfBubbles, in: 0...15, step: 1)
                    .padding()
                                
                Text("\(Int(numberOfBubbles))")
                                    .padding()
                Button(action: {
                                isStartGameActive = true
                            }) {
                                Text("Start Game")
                                    .font(.title)
                            }
                            .disabled(!isStartButtonEnabled)
                            .padding()
                            Spacer()
                        }
                        .onReceive([countdownValue, numberOfBubbles].publisher) { _ in
                            updateStartButtonState()
                        }
                        .background(
                            NavigationLink(
                                destination: StartGameView(),
                                isActive: $isStartGameActive,
                                label: {
                                    EmptyView()
                                })
                            .hidden()
                        )

                    }
    private func updateStartButtonState() {
           isStartButtonEnabled =  countdownValue > 0 && numberOfBubbles > 0
       }
   }
#Preview {
    SettingsView()
}
