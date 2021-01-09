//
//  Grid.swift
//  Memorize
//
//  Created by Minho Choi on 2021/01/05.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    private(set) var items: Array<Item>
    private(set) var viewForItem: (Item) -> ItemView
    
    init(_ items: Array<Item>, viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            body(for: GridLayout(itemCount: items.count, nearAspectRatio: 1.5, in: geometry.size))
        }
    }
    
    private func body(for layout: GridLayout) -> some View {
        ForEach(items) { item in
            body(for: item, in: layout)
        }
    }
    
    private func body(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(matching: item)
        return viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index!))
    }

}
