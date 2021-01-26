//
//  EmojiMemoryGameChooserView.swift
//  Memorize
//
//  Created by Minho Choi on 2021/01/24.
//

import SwiftUI

struct EmojiMemoryGameChooserView: View {
    @EnvironmentObject var store: EmojiMemoryGameStore
    @State private var showAddEditor = false
    @State private var showEditor = false
    @State private var isInEditMode = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(store.stringThemes) { theme in
                        CustomNavigationBar(isInEditMode: $isInEditMode, showEditor: $showEditor, store: store, theme: theme)
                            .popover(isPresented: $showEditor, content: {
                                EmojiSetEditor(
                                    store: store,
                                    themeToAdd: theme,
                                    showEditor: $showEditor
                                )
                                    .frame(minWidth: 300, minHeight: 500)
                            })
                    }.onDelete(perform: { indexSet in
                        indexSet.map { store.stringThemes[$0] }.forEach { theme in
                            store.removeTheme(theme: theme)
                        }
                    })
                    
                }
                .navigationBarItems(
                    trailing:
                        Text(isInEditMode ? "Done":"Edit")
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        withAnimation(.easeIn) {
                            isInEditMode.toggle()
                        }
                })
                Button("Add New Theme", action: {
                    showAddEditor = true
                })
                .popover(
                    isPresented: $showAddEditor,
                    content: {
                        EmojiSetEditor(store: store, themeToAdd: Theme(name: "Enter Theme Name", emojis: [], color: Color.white), showEditor: $showAddEditor)
                            .frame(minWidth: 300, minHeight: 500)
                    })
                
            }
            .navigationTitle(Text("Memorize"))
        }
    }
}


struct EmojiMemoryGameChooserView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameChooserView().environmentObject(EmojiMemoryGameStore())
    }
}
