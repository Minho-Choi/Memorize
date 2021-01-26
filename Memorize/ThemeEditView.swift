//
//  ThemeEditView.swift
//  Memorize
//
//  Created by Minho Choi on 2021/01/26.
//

import SwiftUI

struct EmojiSetEditor: View {
    var store: EmojiMemoryGameStore
    @State var themeToAdd: Theme<String>
    @Binding var showEditor: Bool {
        willSet {
            if themeToAdd.emojis.count < 2 {
//                print("Must enter at least two emojis")
                showAlert = true
            }
        }
        didSet {
            if !showEditor, themeToAdd.emojis.count >= 2 {
                store.addNewTheme(theme: themeToAdd)
            }
        }
    }
    private var isEditMode: Bool {
        store.isContaining(theme: themeToAdd)
    }
    @State private var showAlert = false
    @State private var themeName: String = ""
    @State private var emojisToAdd: String = ""
    
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
                    .alert(isPresented: $showAlert, content: {
                        Alert(
                            title: Text("Must enter at least two emojis"),
                            message: Text("Keep on editing theme?"),
                            primaryButton: .default(Text("Continue")),
                            secondaryButton: .destructive(Text("Exit"))
                        )
                    })
                }
            }
            Form {
                Section(header: Text("Theme Name")) {
                    TextField(themeToAdd.name, text: $themeName, onEditingChanged: { began in
                        if !began {
                            themeToAdd.rename(to: themeName)
                        }
                    })
                }
                Section(header: Text("Emojis")) {
                    TextField("Enter emojis to add", text: $emojisToAdd, onEditingChanged: { began in
                        if !began {
                            themeToAdd.addContents(contents: emojisToAdd.map { "\($0)" }, separator: "")
                            emojisToAdd = ""
                        }
                    })
                }
                Section(header: Text("Emoji List"), footer: Text("Tap emojis to remove")) {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(themeToAdd.emojis, id: \.self) { emoji in
                                Text(emoji).font(.largeTitle)
                                    .onTapGesture {
                                        themeToAdd.removeContent(content: emoji)
                                    }
                            }
                        }
                    }
                }
                Section(header: Text("Theme Color")) {
                    // UIColor와 Color 타입 차이 때문에 color picker의 initial value를 따로 줌
                    ColorPickerView(themeColor: $themeToAdd.color, themeColorC: Color(themeToAdd.color)).frame(height: 80)
                }
                Toggle("Always use every cards", isOn: $themeToAdd.isUsingAllCards)
            }
        }
    }
}
