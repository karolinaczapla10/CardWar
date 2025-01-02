//
//  GameViewModel.swift
//  CardWar
//
//  Created by Karolina on 13/12/2024.
//

//ViewModel
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var playerDeck: [Card] = [] //talia gracza
    @Published var computerDeck: [Card] = [] //talia komputera
    @Published var playerCard: Card? = nil //aktualne zagrane karty gracza
    @Published var computerCard: Card? = nil //aktualne zagrane karty komputera
    @Published var resultMessage = "" // wiadomosc z wynikiem akutalnej rundy
    @Published var playerWonCards: [Card] = [] // karty wygrane po stronie gracza
    @Published var computerWonCards: [Card] = [] // karty wygrane po stronie komputera
    @Published var playerChoices: [Card] = [] // opcje kart dla gracza do wyboru
    
    @Published var isGameOver: Bool = false // flaga konca gry
    @Published var isButtonEnabled: Bool = true // flaga aktywnosci przycisku
    @Published var timerText: String = "03:00" // tekst odliczania czasu
    
    private var model = GameModel()
    private var timer: Timer?
    private var timeRemaining: Int = 180 // 3 minutes in seconds
    
    @Published var isGameStarted = false // Nowa zmienna kontrolująca rozpoczęcie gry

    
    
    init() {
        resetGame()
    }
    
    func playCard(_ card: Card) {
        playerCard = card
        // Usuń wybraną kartę z listy dostępnych kart
        if let index = playerChoices.firstIndex(where: { $0.id == card.id }) {
            playerChoices.remove(at: index)
        }

        // Losowanie nowych kart po wyborze
        drawChoices()
        
        // Zagranie tury
        playTurn()
    }



    func startGameTimer() { // rozpoczyna odliczanie czasu gry
        timeRemaining = 180 // reset the timer
        timerText = "03:00"
        
        timer?.invalidate()
        isButtonEnabled = true // Enable button when game starts

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                self.timerText = self.formatTime(self.timeRemaining)
            } else {
                self.endGame()
                self.resultMessage = "Przekroczono limit czasu. Wygrywa: \(self.winner())"
                timer.invalidate()
            }
        }
    }
    
    private func formatTime(_ time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func playTurn() { // Porównuje karty gracza i komputera, przypisuje zwycięzcy wygrane kart
        guard !playerDeck.isEmpty, !computerDeck.isEmpty else {
            endGame()
            return
        }

        let playerCard = playerDeck.removeFirst()
        let computerCard = computerDeck.removeFirst()

        self.playerCard = playerCard
        self.computerCard = computerCard

        if playerCard.value > computerCard.value {
            playerWonCards.append(playerCard)
            playerWonCards.append(computerCard)
            resultMessage = "Gracz wygrywa tę rundę!"
        } else if playerCard.value < computerCard.value {
            computerWonCards.append(playerCard)
            computerWonCards.append(computerCard)
            resultMessage = "Komputer wygrywa tę rundę!"
        } else {
            resultMessage = "Remis!"
        }

        if playerDeck.isEmpty && computerDeck.isEmpty {
            endGame()
        }
    }

    func endGame() { // Kończy grę, ogłasza zwycięzcę
        isGameOver = true
        isButtonEnabled = false

        if playerWonCards.count > computerWonCards.count {
            resultMessage = "Gracz wygrał grę!"
        } else if playerWonCards.count < computerWonCards.count {
            resultMessage = "Komputer wygrał grę!"
        } else {
            resultMessage = "Gra zakończyła się remisem!"
        }
    }
    
    func drawChoices() {
        // Jeśli są jeszcze dostępne karty, losuj 3
        if playerDeck.count > 3 {
            playerChoices = Array(playerDeck.prefix(3))
        } else {
            playerChoices = playerDeck // Jeśli jest mniej niż 3 karty, pokaż wszystkie dostępne
        }
    }

    func resetGame() {
       let dealtDecks = model.dealHalfDeck()
       playerDeck = dealtDecks.playerDeck
       computerDeck = dealtDecks.computerDeck
       playerCard = nil
       computerCard = nil
       resultMessage = "Zacznij grę!"
       playerWonCards = []
       computerWonCards = []
       isGameOver = false
       isButtonEnabled = false
       timerText = "03:00"
       drawChoices()
   }

    func winner() -> String {
        if playerWonCards.count > computerWonCards.count {
            return "Gracz"
        } else if playerWonCards.count < computerWonCards.count {
            return "Komputer"
        } else {
            return "Remis"
        }
    }
}

