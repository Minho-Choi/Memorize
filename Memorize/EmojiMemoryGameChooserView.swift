//
//  EmojiMemoryGameChooserView.swift
//  Memorize
//
//  Created by Minho Choi on 2021/01/24.
//

import SwiftUI

struct EmojiMemoryGameChooserView: View {
    @EnvironmentObject var store: EmojiMemoryGameStore
    @State private var showEditor = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(store.stringThemes) { theme in
                        CustomNavigationBar(store: store, theme: theme)
                    }.onDelete(perform: { indexSet in
                        indexSet.map { store.stringThemes[$0] }.forEach { theme in
                            store.removeTheme(theme: theme)
                        }
                    })
                }
                Button("Add New Theme", action: {
                    showEditor = true
                })
                .popover(
                    isPresented: $showEditor,
                    content: {
                    EmojiSetEditor(showEditor: $showEditor)
                })
            }
            .navigationTitle(Text("Memorize"))
        }
    }
}

struct CustomNavigationBar: View {
    var store: EmojiMemoryGameStore
    var theme: Theme<String>
    var body: some View {
        NavigationLink(destination:
                        EmojiMemoryGameView(viewModel: EmojiMemoryGame(store: store, themeID: theme.id))
        ) {
            HStack {
                VStack(alignment: .leading) {
                    Text(theme.name)
                        .font(.title)
                        .padding(.vertical, 2)
                    HStack {
                        Image(systemName: "square.grid.2x2.fill")
                            .imageScale(.large)
                            .foregroundColor(Color(theme.color))
                        Text("\(theme.emojis.count * 2) cards")
                        Text(theme.emojis.joined(separator: ""))
                    }.font(.headline)
                }
            }
        }
    }
}

struct EmojiSetEditor: View {
    
    @EnvironmentObject var themeList: EmojiMemoryGameStore
    @Binding var showEditor: Bool {
        didSet {
            
        }
    }
    @State var themeName: String = ""
    @State var themeToAdd: Theme<String> = Theme(name: "Enter Theme Name", emojis: [], color: Color.black)
    
    var body : some View {
        VStack {
            ZStack {
                Text("Add Theme")
                    .font(.headline)
                    .padding()
                HStack {
                    Spacer()
                    Button("Done", action: {
                        showEditor = false
                    })
                    .padding()
                }
            }
            Form {
                Section {
                    TextField("Theme Name", text: $themeName, onEditingChanged: { began in
                        if !began {
                            themeToAdd.rename(to: themeName)
                        }
                    })
                }
                Section {
                    TextField("Theme Name", text: $themeName, onEditingChanged: { began in
                        if !began {
                            themeToAdd.rename(to: themeName)
                        }
                    })
                }
            }
        }
    }
}


struct EmojiMemoryGameChooserView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameChooserView().environmentObject(EmojiMemoryGameStore())
    }
}
