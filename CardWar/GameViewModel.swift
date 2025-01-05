//
//  GameViewModel.swift
//  CardWar
//
//  Created by Karolina on 13/12/2024.
//

//ViewModel
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var playerDeck: [Card] = []
    @Published var computerDeck: [Card] = []
    @Published var playerCard: Card? = nil
    @Published var computerCard: Card? = nil
    @Published var resultMessage = ""
    @Published var playerWonCards: [Card] = []
    @Published var computerWonCards: [Card] = []
    @Published var playerChoices: [Card] = []
    @Published var isGameOver: Bool = false
    @Published var isButtonEnabled: Bool = true
    @Published var timerText: String = "03:00"
    private var model = GameModel()
    private var timer: Timer?
    private var timeRemaining: Int = 180
    @Published var isGameStarted = false

    init() {
        resetGame()
    }

    func playCard(_ card: Card) {
        playerCard = card
        if let index = playerDeck.firstIndex(where: { $0.id == card.id }) {
            playerDeck.remove(at: index)
        }
        drawChoices()
        playTurn()
    }

    func startGameTimer() {
        timeRemaining = 180
        timerText = "03:00"
        timer?.invalidate()
        isButtonEnabled = true

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

    func playTurn() {
        guard let playerCard = self.playerCard else {
            resultMessage = "Gracz musi wybrać kartę!"
            return
        }
        
        guard !computerDeck.isEmpty else {
            endGame()
            return
        }

        let computerCard = computerDeck.removeFirst()
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

        drawChoices()

        if playerDeck.isEmpty && computerDeck.isEmpty {
            endGame()
        }
    }

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

    func drawChoices() {
        if playerDeck.count > 3 {
            playerChoices = Array(playerDeck.prefix(3))
        } else {
            playerChoices = playerDeck
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
