//
//  MemoryGame.swift
//  Memorize
//
//  Created by Minho Choi on 2021/01/01.
//

import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var score: Int = 0
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
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
            cards.append(Card(id: pairIndex * 2, content: content))
            cards.append(Card(id: pairIndex * 2 + 1, content: content))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        
        var id : Int
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var isSeen: Bool = false
        var content: CardContent
        
        // MARK: - Bonus Time

        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up

        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6

        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}

struct Theme<CardContent>: Codable, Identifiable where CardContent: Codable {
    
    var id: UUID = UUID()
    var name: String
    var emojis: Array<CardContent>
    var numberOfCardsToShow: Int?
    var color: UIColor.RGB
    var isUsingAllCards: Bool {
        get {
            numberOfCardsToShow != nil
        }
        set {
            if newValue {
                numberOfCardsToShow = emojis.count
            } else {
                numberOfCardsToShow = nil
            }
        }
    }
    
    init(name: String, emojis: Array<CardContent>, color: Color) {
        self.name = name
        self.emojis = emojis
        self.color = UIColor(color).rgb
        self.numberOfCardsToShow = nil
    }
    
    init(name: String, emojis: Array<CardContent>, numberOfCardsToShow: Int, color: Color) {
        self.init(name: name, emojis: emojis, color: color)
        self.numberOfCardsToShow = numberOfCardsToShow
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    mutating func rename(to newName: String) {
        self.name = newName
    }
    
    mutating func addContents(contents: Array<CardContent>, separator: CardContent) where CardContent: Equatable {
        for content in contents {
            if content != separator {
                emojis.append(content)
            }
        }
    }
    
    mutating func removeContent(content: CardContent) where CardContent: Equatable {
        for index in 0..<emojis.count {
            if emojis[index] == content {
                emojis.remove(at: index)
                break
            }
        }
    }
    
}

