//
//  CardView.swift
//  CardWar
//
//  Created by Karolina on 13/12/2024.
//

import SwiftUI
import CardWar

//struktura pojedycznej karty

struct CardView: View {
    // card: Obiekt karty zawierający jej wartość i kolor.
    // onCardPlayed: Zakończenie (closure), które jest wywoływane, gdy karta jest kliknięta i zagrana.
    var card: Card
    var onCardPlayed: ((Card) -> Void)?

    // Stan do śledzenia przesunięcia pionowego dla animacji karty po kliknięciu.
    @State private var offset: CGFloat = 0

    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(Color.white)
                base.strokeBorder(lineWidth: 2)
                VStack {
                    Text(suitSymbol(for: card.suit)) // Wyświetlanie symbolu koloru
                        .font(.largeTitle) // Rozmiar czcionki dla symbolu koloru
                    Text(card.rank) // Wyświetlanie rangi karty (np. 10, Król, As)
                        .font(.title)
                }
            }
        }
        .frame(width: 100, height: 150)
        .offset(y: offset)
        
        // Dodanie gestu tapnięcia na kartę.
        // Stosujemy animację, gdy karta zostaje kliknięta (karta przesuwa się do góry o 100 pkt).
        .onTapGesture {
            withAnimation(.easeIn(duration: 0.5)) {
                offset = -100
            }
            // Po zakończeniu animacji wywołujemy closure onCardPlayed, aby powiadomić o zagranej karcie.
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
