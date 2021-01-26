//
//  ColorPickerView.swift
//  Memorize
//
//  Created by Minho Choi on 2021/01/26.
//

import SwiftUI

struct ColorPickerView: View {
    
    var presetColors = [Color.black, Color.blue, Color.red, Color.yellow, Color.pink, Color.orange, Color.green, Color.gray, Color.purple]
    
    @Binding var themeColor: UIColor.RGB
    @State var themeColorC: Color
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
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
                                    themeColor = UIColor(color).rgb
                                    themeColorC  = color
                                }
                        }
                    }
                }
            }
            Divider()
            ColorPicker(selection: $themeColorC, label: {
                Text("Custom Colors")
            }).onChange(of: themeColorC, perform: { value in
                themeColor = UIColor(value).rgb
            })
        }
    }
    
}

//struct ColorPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ColorPickerView()
//    }
//}
