//
//  NavBarView.swift
//  Memorize
//
//  Created by Minho Choi on 2021/01/26.
//

import SwiftUI


struct CustomNavigationBar: View {
    @Binding var isInEditMode: Bool
    @Binding var showEditor: Bool
    @State var emojiEditView: EmojiSetEditor?
    var store: EmojiMemoryGameStore
    var theme: Theme<String>
    var body: some View {
        NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(store: store, themeID: theme.id)))
        {
            HStack {
                if isInEditMode {
                    VStack(spacing: 10) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .onTapGesture {
                                withAnimation(.easeIn) {
                                    store.removeTheme(theme: theme)
                                }
                            }
                        Image(systemName: "paintbrush")
                            .foregroundColor(Color(#colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)))
                            .onTapGesture {
                                print("Tapped \(theme.name)")
                                showEditor = true
                            }
                    }.imageScale(.large)
                }
                VStack(alignment: .leading) {
                    Text(theme.name)
                        .font(.title)
                        .padding(.vertical, 2)
                    HStack {
                        Image(systemName: "square.grid.2x2.fill")
                            .imageScale(.large)
                            .foregroundColor(Color(theme.color))
                        if let num = theme.numberOfCardsToShow {
                            Text("\(num * 2) cards")
                        } else {
                            Text("≤ \(theme.emojis.count * 2) cards")
                        }
                        Text(theme.emojis.joined(separator: ""))
                    }.font(.headline)
                }.transformEffect(.identity)
            }
        }
        .sheet(
            isPresented: $showEditor,
            content: {
            EmojiSetEditor(
                store: store,
                themeToAdd: store.searchTheme(themeID: theme.id) ?? theme,
                showEditor: $showEditor
            ).frame(minWidth: 300, minHeight: 500)
        }
    )
    }
}
