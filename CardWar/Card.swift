//
//  Card.swift
//  CardWar
//
//  Created by Karolina on 13/12/2024.
//

import SwiftUI

//model
//modeluje pojedyncza karte w talii

struct Card: Identifiable {
    let id = UUID() // unikalny identyfikator karty
    let value: Int // wartosc karty od 2 do 14, gdzie 14 to AS
    let suit: String // kolor karty np. heart, dimonds

    //obliczana wartosc zwracajaca symbol J,Q,K,A
    var rank: String {
            switch value {
            case 11:
                return "J"
            case 12:
                return "Q"
            case 13:
                return "K"
            case 14:
                return "A"
            default:
                return "\(value)"
            }
        }
}

//GameModel tworzy pelna talie kart 42 karty

class GameModel {
    private var cards: [Card] = []

    //tworzy talie i tasuje ja
    init() {
        let suits = ["Hearts", "Diamonds", "Clubs", "Spades"]
        for suit in suits {
            for value in 2...14 { // 2 to Ace (represented as 14)
               cards.append(Card(value: value, suit: suit))
               // cards.append(Card(value: 2, suit: suit))
            }
        }
        cards.shuffle()
    }
    
    // dzieli talię na dwie połowy (dla gracza i komputera).
    func dealHalfDeck() -> (playerDeck: [Card], computerDeck: [Card]) {
        let halfDeck = Array(cards.prefix(26))
        let remainingDeck = Array(cards.suffix(26))
        return (playerDeck: halfDeck, computerDeck: remainingDeck)
    }

    // zwraca pierwszą kartę z talii i usuwa ją
    func dealCard() -> Card? {
        return cards.isEmpty ? nil : cards.removeFirst()
    }

    // czy talia jest pusta
    var isEmpty: Bool {
        cards.isEmpty
    }

    // lista pozostalych kart w talii
    var count: Int {
        cards.count
    }
}

#Preview {
    VStack {
        Text("Podgląd karty:")
        if let card = GameModel().dealCard() {
            Text("\(card.value) of \(card.suit)")
                .padding()
                .background(Color.yellow.opacity(0.3))
                .cornerRadius(8)
        } else {
            Text("Brak karty")
        }
    }
}
