//
//  MemoryGame.swift
//  Memorize
//
//  Created by Minho Choi on 2021/01/01.
//

import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable {
    var cards: Array<Card>
    var score: Int = 0
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    mutating func choose(card: Card) {
//        print("card chosen: \(card)")
        if let chosenIndex: Int = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                } else {    // not matching case
                    if cards[chosenIndex].isSeen && cards[potentialMatchIndex].isSeen {
                        score -= 2
                    }
                    else if cards[chosenIndex].isSeen || cards[potentialMatchIndex].isSeen {
                        score -= 1
                        cards[chosenIndex].isSeen = true
                        cards[potentialMatchIndex].isSeen = true
                    } else {
                        cards[chosenIndex].isSeen = true
                        cards[potentialMatchIndex].isSeen = true
                    }
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var isSeen: Bool = false
        var content: CardContent
        var id : Int
    }
}

struct Theme<CardContent>{
    let name: String
    let emojis: Array<CardContent>
    var numberOfCardsToShow: Int?
    let color: Color
    
    init(name: String, emojis: Array<CardContent>, color: Color) {
        self.name = name
        self.emojis = emojis
        self.color = color
        self.numberOfCardsToShow = nil
    }
    
    init(name: String, emojis: Array<CardContent>, numberOfCardsToShow: Int, color: Color) {
        self.init(name: name, emojis: emojis, color: color)
        self.numberOfCardsToShow = numberOfCardsToShow
    }
    
}
