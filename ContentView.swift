import SwiftUI

struct ContentView: View {
    // Game state variables
    @State private var plantImages = ["leaf1", "leaf2", "leaf3", "leaf4", "leaf5"] // Add your image asset names
    @State private var plantNames = ["Maple", "Poison Ivy", "Tomato", "Gingko Biloba", "Cannabis"] // Plant names
    @State private var currentRound = 0
    @State private var score = 0
    @State private var options = [String]()
    @State private var selectedPlant = ""
    @State private var showScore = false
    
    var body: some View {
            ZStack {
                // Add background color
                Color(.systemGreen)
                    .ignoresSafeArea() // Apply background to full screen

                VStack {
                    Spacer()
                    Text("Guess the Grass")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)

                    Spacer()

                    if !showScore {
                        // Display the silhouette image
                        if currentRound < plantImages.count {
                            Image(plantImages[currentRound])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                                .padding()
                        }

                        // Show the buttons for guessing
                        ForEach(0..<3, id: \.self) { index in
                            if index < options.count {
                                Button(action: {
                                    checkAnswer(option: options[index])
                                }) {
                                    Text(options[index])
                                        .font(.title2)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .padding(.horizontal, 40)
                                }
                            }
                        }
                    } else {
                        // Show a message and the score after 5 rounds
                        Text("Congratulations!")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()

                        Text("You scored \(score)/5")
                            .font(.largeTitle)
                            .padding()

                        // Restart button
                        Button(action: resetGame) {
                            Text("Play Again")
                                .font(.title2)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal, 40)
                        }
                    }

                    Spacer() 

                } 
                .onAppear {
                    loadRound()
                }
            }
        }
    
    // Function to check the answer and go to the next round
    func checkAnswer(option: String) {
        print("Selected Option: \(option), Correct Answer: \(selectedPlant)")
        
        if option == selectedPlant {
            score += 1
        }
        
        if currentRound < plantImages.count - 1 { // Ensure we don't exceed array bounds
            currentRound += 1
            print("Moving to round: \(currentRound)")
            loadRound()
        } else {
            print("Finished all rounds")
            showScore = true
        }
    }
    
    // Function to load the current round's data
    func loadRound() {
        if currentRound >= plantImages.count || currentRound >= plantNames.count {
            return
        }

        // Set the correct answer for this round
        selectedPlant = plantNames[currentRound]

        // Create options list including the correct answer
        var tempOptions = [selectedPlant]
        
        // Add two more random options, excluding the correct answer
        while tempOptions.count < 3 {
            let randomOption = plantNames.randomElement()!
            if !tempOptions.contains(randomOption) {
                tempOptions.append(randomOption)
            }
        }
        
        // Shuffle options to randomize placement
        options = tempOptions.shuffled()
        
        print("Options for this round: \(options)") // For debugging purposes
    }
    // Reset the game
    func resetGame() {
        currentRound = 0
        score = 0
        showScore = false
        loadRound()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
