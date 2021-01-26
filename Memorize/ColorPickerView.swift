//
//  ColorPickerView.swift
//  Memorize
//
//  Created by Minho Choi on 2021/01/26.
//

import SwiftUI

struct ColorPickerView: View {
    
    var presetColors = [Color.black, Color.blue, Color.red, Color.yellow, Color.pink, Color.orange, Color.green, Color.gray, Color.purple]
    
    @Binding var themeColor: Color
    
    var body: some View {
        VStack {
            HStack {
                GeometryReader { geometry in
                    Group {
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack {
                                ForEach(presetColors, id: \.self) { color in
                                    Rectangle()
                                        .foregroundColor(color)
                                        .frame(
                                            width: geometry.size.width * 0.1,
                                            height: geometry.size.height,
                                            alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .padding(geometry.size.width * 0.002)
                                        .onTapGesture {
                                            themeColor = color
                                        }
                                }
                            }
                        }
                    }
                }
            }
            Divider()
            ColorPicker(selection: $themeColor, label: {
                Text("Custom Colors")
            })
        }
    }
    
}

//struct ColorPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ColorPickerView()
//    }
//}
