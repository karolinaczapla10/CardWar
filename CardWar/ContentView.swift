//
//  ContentView.swift
//  CardWar
//
//  Created by Karolina on 13/12/2024.
//
//  ContentView.swift
//  CardWar
//
//  Created by Karolina on 13/12/2024.
//
import SwiftUI
struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Wojna Kart")
                .font(.largeTitle)
                .fontWeight(.bold)

            HStack {
                VStack {
                    Text("Gracz")
                        .font(.title)
                    if viewModel.isGameStarted, let card = viewModel.playerCard {
                        CardView(card: card)
                    } else {
                        Text("Brak karty")
                            .opacity(viewModel.isGameStarted ? 0 : 1) // Ukryj tekst przed rozpoczęciem gry
                    }
                    Text("Karty: \(viewModel.playerDeck.count + viewModel.playerWonCards.count)")
                        .font(.headline)
                }

                Spacer()

                VStack {
                    Text("Komputer")
                        .font(.title)
                    if viewModel.isGameStarted, let card = viewModel.computerCard {
                        CardView(card: card)
                    } else {
                        Text("Brak karty")
                            .opacity(viewModel.isGameStarted ? 0 : 1) // Ukryj tekst przed rozpoczęciem gry
                    }
                    Text("Karty: \(viewModel.computerDeck.count + viewModel.computerWonCards.count)")
                        .font(.headline)
                }
            }
            .padding()

            Text(viewModel.resultMessage)
                .font(.title2)
                .padding()

            Text("Pozostały czas: \(viewModel.timerText)")
                .font(.headline)
                .padding()

            // Karty wybierane przez gracza
            if viewModel.isGameStarted {
                HStack {
                    ForEach(viewModel.playerChoices) { card in
                        CardView(card: card, onCardPlayed: { playedCard in
                            viewModel.playCard(playedCard)

                            withAnimation(.easeIn(duration: 0.5)) {
                                viewModel.playerChoices = [] // Czyszczenie wyboru
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                                viewModel.drawChoices() // Losowanie nowych kart
                            }
                        })
                    }
                }
            } else {
                // Karty są niewidoczne, jeśli gra nie została rozpoczęta
                Text("Karty będą dostępne po rozpoczęciu gry.")
                    .foregroundColor(.gray)
            }

            HStack(spacing: 20) {
                Button(action: {
                    viewModel.resetGame()
                    viewModel.startGameTimer()
                    viewModel.resultMessage = "Gra rozpoczęta"  // Zniknięcie napisu po rozpoczęciu nowej gry
                    viewModel.isGameStarted = true // Ustawienie gry jako rozpoczętej
                }) {
                    Text("Nowa Gra")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .alert("Koniec gry", isPresented: $viewModel.isGameOver) {
                    Button("OK", role: .cancel) {
                        // After closing the alert, reset the game and show new cards
                        viewModel.resetGame()
                        viewModel.startGameTimer()
                        viewModel.resultMessage = "Gra rozpoczęta"
                        viewModel.isGameStarted = true
                        viewModel.drawChoices() // Draw new cards after alert is closed
                    }
                } message: {
                    Text(viewModel.resultMessage)
                }
    }
}


#Preview {
    ContentView()
}
