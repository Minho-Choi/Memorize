//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Minho Choi on 2021/01/01.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGameWrapper<String> = EmojiMemoryGame.createMemoryGame()
    
    fileprivate static let stringThemes: Array<Theme<String>> = [
        Theme<String>(name: "Halloween", emojis: ["🎃","🕷","👻","🦇","🕯"], numberOfCardsToShow: 5, color: Color.orange),
        Theme<String>(name: "Faces", emojis: ["😀","😃","🤣","🥰","🤪","😎"], numberOfCardsToShow: 6, color: Color.yellow),
        Theme<String>(name: "Sports", emojis: ["⚽️","🏀","🏈","⚾️","🎱","🎾"], numberOfCardsToShow: 6, color: Color.blue),
        Theme<String>(name: "Animals", emojis: ["🐶","🐱","🐭","🐰","🦊"], numberOfCardsToShow: 5, color: Color.red),
        Theme<String>(name: "Insects", emojis: ["🐝","🦋","🐜","🐞","🐛","🪲"], numberOfCardsToShow: 6, color: Color.black),
        Theme<String>(name: "Fruits", emojis: ["🍐","🍎","🍊","🍉","🍇","🍓","🍍","🥝"], numberOfCardsToShow: 8, color: Color.green)
    ]
        
    static func createMemoryGame() -> MemoryGameWrapper<String> {
        let chosenTheme = stringThemes[Int.random(in: 0...stringThemes.count - 1)]
        print(chosenTheme.json?.utf8 ?? "")
        let emojis: Array<String> = chosenTheme.emojis
        var currentMemoryGame: MemoryGame<String>
        if let cardNumbers = chosenTheme.numberOfCardsToShow {
            currentMemoryGame = MemoryGame<String>(numberOfPairsOfCards: cardNumbers) { pairIndex in
                return emojis[pairIndex]
            }
        } else {
            currentMemoryGame = MemoryGame<String>(numberOfPairsOfCards: Int.random(in: 2...emojis.count)) { pairIndex in
                return emojis[pairIndex]
            }
        }
        return MemoryGameWrapper(memoryGame: currentMemoryGame, themeName: chosenTheme.name, themeColor: Color(chosenTheme.color))
    }
    
    // MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        model.memoryGame.cards
    }
    
    var name: String {
        model.themeName
    }
    
    var color: Color {
        model.themeColor
    }
    
    var score: Int {
        model.memoryGame.score
    }
    
    // MARK: - Intent(s)
    func choose(card: MemoryGame<String>.Card) {
        model.memoryGame.choose(card: card)
    }
    
    func regame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
    
}

struct MemoryGameWrapper<CardContent> where CardContent: Equatable {
    var memoryGame: MemoryGame<CardContent>
    var themeName: String
    var themeColor: Color
}

extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8 ) }
}
