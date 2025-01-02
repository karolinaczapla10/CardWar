//
//  CardView.swift
//  CardWar
//
//  Created by Karolina on 13/12/2024.
//

import SwiftUI
import CardWar

struct CardView: View {
    var card: Card
    var onCardPlayed: ((Card) -> Void)?

    @State private var offset: CGFloat = 0

    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(Color.white)
                base.strokeBorder(lineWidth: 2)
                VStack {
                    Text(suitSymbol(for: card.suit))
                        .font(.largeTitle)
                    Text(card.rank)
                        .font(.title)
                }
            }
        }
        .frame(width: 100, height: 150)
        .offset(y: offset)
        .onTapGesture {
            withAnimation(.easeIn(duration: 0.5)) {
                offset = -100
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onCardPlayed?(card)
            }
        }
    }

    func suitSymbol(for suit: String) -> String {
        switch suit {
        case "Hearts": return "♥️"
        case "Diamonds": return "♦️"
        case "Clubs": return "♣️"
        case "Spades": return "♠️"
        default: return "?"
        }
    }
}




#Preview {
    CardView(card: Card(value: 10, suit: "Hearts"))
}
