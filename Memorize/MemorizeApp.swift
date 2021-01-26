//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Minho Choi on 2021/01/01.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var store = EmojiMemoryGameStore()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameChooserView().environmentObject(store)
        }
    }
}
