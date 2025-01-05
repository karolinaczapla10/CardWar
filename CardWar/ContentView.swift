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
    // Tworzymy obiekt viewModel
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Wojna Kart")
                .font(.largeTitle)
                .fontWeight(.bold)

            HStack {
                VStack {
                    // Wyświetlanie karty gracza, jeśli gra została rozpoczęta
                    Text("Gracz")
                        .font(.title)
                    if viewModel.isGameStarted, let card = viewModel.playerCard {
                        CardView(card: card)
                    } else {
                        // Jeśli gra się nie zaczęła, wyświetl tekst "Brak karty"
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
            // Wyświetlanie komunikatu o wyniku gry
            Text(viewModel.resultMessage)
                .font(.title2)
                .padding()
            
            // Wyświetlanie pozostałego czasu gry
            Text("Pozostały czas: \(viewModel.timerText)")
                .font(.headline)
                .padding()

            // Wybór kart przez gracza, tylko gdy gra została rozpoczęta
            if viewModel.isGameStarted {
                HStack {
                    // Pętla do wyświetlania kart gracza, z akcją zagrania karty
                    ForEach(viewModel.playerChoices) { card in
                        CardView(card: card, onCardPlayed: { playedCard in
                            // Akcja zagrania karty przez gracza
                            viewModel.playCard(playedCard)

                            // Animacja usunięcia wybranych kart po ich zagraniu
                            withAnimation(.easeIn(duration: 0.5)) {
                                viewModel.playerChoices = [] // Czyszczenie wyboru
                            }
                            // Losowanie nowych kart po 0.9 sekundy
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

            // Przycisk do rozpoczęcia nowej gry
            HStack(spacing: 20) {
                Button(action: {
                    // Akcja przycisku - resetowanie gry i rozpoczęcie od nowa
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
        // Alert, który pojawia się po zakończeniu gry
        .padding()
        .alert("Koniec gry", isPresented: $viewModel.isGameOver) {
                    Button("OK", role: .cancel) {
                        // Po zamknięciu alertu resetujemy grę i pokazujemy nowe karty
                        viewModel.resetGame()
                        viewModel.startGameTimer()
                        viewModel.resultMessage = "Gra rozpoczęta"
                        viewModel.isGameStarted = true
                        viewModel.drawChoices() //Losowanie nowych kart po zamknięciu alertu
                    }
                } message: {
                    // Komunikat o wyniku gry (np. "Wygrałeś!" lub "Przegrałeś!")
                    Text(viewModel.resultMessage)
                }
    }
}


#Preview {
    ContentView()
}
