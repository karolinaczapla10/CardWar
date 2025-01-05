//
//  GameViewModel.swift
//  CardWar
//
//  Created by Karolina on 13/12/2024.
//

//ViewModel
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var playerDeck: [Card] = [] // Talia gracza
       @Published var computerDeck: [Card] = [] // Talia komputera
       @Published var playerCard: Card? = nil // Karta gracza
       @Published var computerCard: Card? = nil // Karta komputera
       @Published var resultMessage = "" // Komunikat o wyniku rundy
       @Published var playerWonCards: [Card] = [] // Karty wygrane przez gracza
       @Published var computerWonCards: [Card] = [] // Karty wygrane przez komputer
       @Published var playerChoices: [Card] = [] // Wybór kart gracza
       @Published var isGameOver: Bool = false // Czy gra zakończona
       @Published var isButtonEnabled: Bool = true // Czy przycisk jest aktywowany
       @Published var timerText: String = "03:00" // Czas gry
       private var model = GameModel() // Model gry
       private var timer: Timer? // Timer do gry
       private var timeRemaining: Int = 180 // Pozostały czas gry (w sekundach)
       @Published var isGameStarted = false // Czy gra została rozpoczęta

    init() {
        resetGame()
    }

    // Funkcja do zagrania kartą
    func playCard(_ card: Card) {
        playerCard = card
        if let index = playerDeck.firstIndex(where: { $0.id == card.id }) {
            playerDeck.remove(at: index)  // Usunięcie karty z talii gracza
        }
        drawChoices() // Losowanie nowych kart
        playTurn() // Rozpoczęcie tury
    }

    // Funkcja do rozpoczęcia timera gry
    func startGameTimer() {
        timeRemaining = 180 // Ustawienie początkowego czasu (3 minuty)
        timerText = "03:00"
        timer?.invalidate() // Zatrzymanie poprzedniego timera
        isButtonEnabled = true // Aktywowanie przycisków

        // Uruchomienie nowego timera
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

    // Funkcja do formatowania czasu (minuty:sekundy)
    private func formatTime(_ time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // Funkcja do rozegrania tury
    func playTurn() {
        guard let playerCard = self.playerCard else {
            resultMessage = "Gracz musi wybrać kartę!"
            return
        }
        
        guard !computerDeck.isEmpty else {
            endGame() // Zakończenie gry, jeśli talia komputera jest pusta
            return
        }

        let computerCard = computerDeck.removeFirst() // Wylosowanie karty przez komputer
        self.computerCard = computerCard
        
        // Porównanie kart i przypisanie wyniku tury
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

        drawChoices() // Losowanie nowych kart po zakończeniu tury
        
        // Zakończenie gry, jeśli obie talie są puste
        if playerDeck.isEmpty && computerDeck.isEmpty {
            endGame()
        }
    }

    // Funkcja do zakończenia gry
    func endGame() {
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
    
    // Funkcja do losowania wyboru kart dla gracza
    func drawChoices() {
        if playerDeck.count > 3 {
            playerChoices = Array(playerDeck.prefix(3)) // Losowanie 3 kart z talii gracza
        } else {
            playerChoices = playerDeck //jezeli jest mniej niz 3 to bierzemy wszytskie
        }
    }
    
    // Funkcja do resetowania gry
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

    // Funkcja do określenia zwycięzcy gry
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
