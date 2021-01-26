//
//  EmojiMemoryGameStore.swift
//  Memorize
//
//  Created by Minho Choi on 2021/01/24.
//

import SwiftUI

class EmojiMemoryGameStore: ObservableObject {

    @Published var stringThemes: Array<Theme<String>> = [
        Theme<String>(name: "Halloween", emojis: ["🎃","🕷","👻","🦇","🕯"], numberOfCardsToShow: 5, color: Color.orange),
        Theme<String>(name: "Faces", emojis: ["😀","😃","🤣","🥰","🤪","😎"], numberOfCardsToShow: 6, color: Color.yellow),
        Theme<String>(name: "Sports", emojis: ["⚽️","🏀","🏈","⚾️","🎱","🎾"], numberOfCardsToShow: 6, color: Color.blue),
        Theme<String>(name: "Animals", emojis: ["🐶","🐱","🐭","🐰","🦊"], numberOfCardsToShow: 5, color: Color.red),
        Theme<String>(name: "Insects", emojis: ["🐝","🦋","🐜","🐞","🐛","🪲"], numberOfCardsToShow: 6, color: Color.black),
        Theme<String>(name: "Fruits", emojis: ["🍐","🍎","🍊","🍉","🍇","🍓","🍍","🥝"], numberOfCardsToShow: 8, color: Color.green)
    ]
    
    public func renameTheme(which originalThemeName: String, to themeName: String) {
        for index in 0..<stringThemes.count {
            if stringThemes[index].name == originalThemeName {
                stringThemes[index].rename(to: themeName)
            }
        }
    }
    
    public func addNewTheme(theme: Theme<String>) {
        for existingTheme in stringThemes.enumerated() {
            if existingTheme.element.id == theme.id {
                stringThemes.replaceSubrange(existingTheme.offset..<existingTheme.offset + 1, with: [theme])
                return
            }
        }
        stringThemes.append(theme)
    }
    
    public func removeTheme(theme: Theme<String>) {
        for index in 0..<stringThemes.count {
            if stringThemes[index].id == theme.id {
                stringThemes.remove(at: index)
                break
            }
        }
    }
    
    public func isContaining(theme: Theme<String>) -> Bool {
        for existingTheme in stringThemes {
            if existingTheme.id == theme.id {
                return true
            }
        }
        return false
    }
    
    func createMemoryGame(selectedThemeID: UUID?) -> MemoryGameWrapper<String> {
        var chosenTheme = stringThemes[Int.random(in: 0...stringThemes.count - 1)]
        for theme in stringThemes {
            if let unwrappedThemeID = selectedThemeID, theme.id == unwrappedThemeID {
                chosenTheme = theme
            }
        }
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
