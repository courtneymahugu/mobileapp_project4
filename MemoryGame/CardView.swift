//
//  CardView.swift
//  MemoryGame
//
//  Created by Courtney Mahugu on 4/1/25.
//

import SwiftUI

struct CardView: View {
    let card: Card

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(card.isMatched ? Color.clear : card.isFaceUp ? Color.white : Color.blue)
                .frame(height: 100)
                .shadow(radius: 5)

            if card.isFaceUp && !card.isMatched {
                Text(card.content)
                    .font(.largeTitle)
            }
        }
        .opacity(card.isMatched ? 0 : 1)
        .animation(.easeInOut, value: card.isMatched)
    }
}

