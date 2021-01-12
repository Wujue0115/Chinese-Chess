//
//  TestView.swift
//  ChineseChess
//
//  Created by 鄭子輿 on 2020/12/29.
//

import SwiftUI

struct TestView: View {
    @State var style: Int = 0
    var body: some View {
//        NavigationView {
        VStack {
            Picker(selection: $style, label: Text("Style")) {
                ForEach(0..<5) { i in
                    Text("Style: \(i)").tag(i)
                        .frame(width: .infinity, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
            }
            
        }
//                        Text("selection day: \()")
        
//            Form {
//                Section {
//                    VStack {
//                        Picker(selection: $style, label: Text("Style")) {
//                            ForEach(0..<5) { i in
//                                Text("Style: \(i)").tag(i)
//                            }
//                        }
////                        Text("selection day: \()")
//                    }
//
//                }
//            }
//            .navigationBarHidden(true)
//        }
        
//            Image(uiImage: UIImage(named: "Background.jpg")!)
//                .resizable()
//                .edgesIgnoringSafeArea(.all)
//                .opacity(0.7)
//                .frame(width: UIScreen.main.bounds.width, height: geo.size.height * 0.7)
//                .border(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), width: 3)
//                .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

struct VerticalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon
            configuration.title
        }
    }
}
