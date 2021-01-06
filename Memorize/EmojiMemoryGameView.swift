//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Minho Choi on 2021/01/01.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame

    var body: some View {
        VStack {
            HStack {
                Text(viewModel.name)
                Spacer()
                Text("Score: " + String(viewModel.score))
            }
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    viewModel.choose(card: card)
                }
                .padding(5)
            }
            .foregroundColor(viewModel.color)
            Button("New Game") {
                viewModel.regame()
            }
                .cornerRadius(10.0)
        }
        .font(.title)
        .padding()
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card 
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                    Text(card.content)
                } else {
                    if !card.isMatched {
                        RoundedRectangle(cornerRadius: cornerRadius).fill()
                    }
                    // else don't draw cards
                }
            }
            .font(.system(size: fontSize(for: geometry.size)))
        }
    }
    
    //MARK: - Drawing Constraints
    
    let cornerRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3.0
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.height, size.width) * 0.75
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
