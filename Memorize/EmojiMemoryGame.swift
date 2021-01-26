//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Minho Choi on 2021/01/01.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGameWrapper<String>
    private var store: EmojiMemoryGameStore
    
    var selectedThemeID: UUID
    
    init(store: EmojiMemoryGameStore, themeID: UUID) {
        self.model = store.createMemoryGame(selectedThemeID: themeID)
        self.selectedThemeID = themeID
        self.store = store
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
        model = store.createMemoryGame(selectedThemeID: selectedThemeID)
    }
    
}


