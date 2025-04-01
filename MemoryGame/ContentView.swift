//
//  ContentView.swift
//  MemoryGame
//
//  Created by Courtney Mahugu on 4/1/25.
//
import SwiftUI

// MARK: - Model
struct Card: Identifiable {
    let id = UUID()
    let content: String
    var isFaceUp = false
    var isMatched = false
}

// MARK: - Main View
struct ContentView: View {
    @State private var numberOfPairs = 2                       // Number of unique card pairs
    @State private var cards: [Card] = []                      // Game deck
    @State private var firstSelectedIndex: Int? = nil          // Index of first selected card

    // Emoji options to randomly choose from
    private let allEmojis = ["🐶", "🐱", "🐼", "🐸", "🦊", "🐵", "🐯", "🐰"]

    var body: some View {
        VStack {
            // Title
            Text("Memory Game")
                .font(.largeTitle)
                .padding()

            // Picker for selecting number of pairs
            Picker("Number of Pairs", selection: $numberOfPairs) {
                ForEach([2, 4, 6, 8], id: \.self) { number in
                    Text("\(number)").tag(number)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: numberOfPairs) { _ in
                resetGame()
            }

            // Scrollable card grid
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 16) {
                    ForEach(cards.indices, id: \.self) { index in
                        let card = cards[index]
                        CardView(card: card)
                            .onTapGesture {
                                handleTap(on: index)
                            }
                    }
                }
                .padding()
            }

            // Reset button
            Button("Reset Game") {
                resetGame()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .onAppear(perform: resetGame) // Initialize the game when view appears
    }

    // MARK: - Game Logic

    func resetGame() {
        let chosenEmojis = allEmojis.shuffled().prefix(numberOfPairs)
        cards = Array(chosenEmojis + chosenEmojis)
            .map { Card(content: $0) }
            .shuffled()
        firstSelectedIndex = nil
    }

    func handleTap(on index: Int) {
        guard !cards[index].isFaceUp, !cards[index].isMatched else { return }

        if let firstIndex = firstSelectedIndex {
            // Flip the second card
            cards[index].isFaceUp = true

            // Check for match
            if cards[firstIndex].content == cards[index].content {
                cards[firstIndex].isMatched = true
                cards[index].isMatched = true
            } else {
                // Flip back if not matched after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    cards[firstIndex].isFaceUp = false
                    cards[index].isFaceUp = false
                }
            }

            // Clear the selection
            firstSelectedIndex = nil
        } else {
            // Flip all unmatched cards face-down before starting new selection
            for i in cards.indices where !cards[i].isMatched {
                cards[i].isFaceUp = false
            }

            cards[index].isFaceUp = true
            firstSelectedIndex = index
        }
    }
}
