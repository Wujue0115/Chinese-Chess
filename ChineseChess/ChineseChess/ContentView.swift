//
//  ContentView.swift
//  ChineseChess
//
//  Created by 鄭子輿 on 2020/12/21.
//

import SwiftUI

let screen_height = UIScreen.main.bounds.height
let screen_width = UIScreen.main.bounds.width

struct ContentView: View {
//    @Environment(\.presentationMode) var presentationMode
    let chessboardshow: ChessBoard = ChessBoard()
    @State private var selection: String? = nil
    
    var body: some View {
        NavigationView {
            Color(#colorLiteral(red: 1, green: 0.9766529202, blue: 0.7833630443, alpha: 1))
                .overlay(ZStack {
                    
                    NavigationLink(destination: GameView(), tag: "gameview", selection: $selection) { EmptyView() }
                    Button(action: {
                        selection = "gameview"
                    }) {
                        Label("開始棋局", systemImage: "forward.fill")
                            .font(.system(size: screen_width * 0.07, weight: .bold))
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: 1, y: 1)
                            .frame(width: screen_width * 0.52, height: screen_width * 0.12, alignment: .center)
                            .background(Color(#colorLiteral(red: 0.8541538119, green: 0.5734136701, blue: 0.09998553246, alpha: 1)))
                            .cornerRadius(15)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 3, x: 2, y: 2)
                            .labelStyle(HorizontalLabelStyle())
                    }
                    .position(x: screen_width * 0.5, y: screen_height * 0.35)
                    
//                    NavigationLink(destination: TestView(), tag: "testview", selection: $selection) { EmptyView() }
//                    Button(action: {
//                        selection = "testview"
//                    }) {
//                        Label("遊戲設定", systemImage: "gearshape.fill")
//                            .font(.system(size: screen_width * 0.07, weight: .bold))
//                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
//                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: 1, y: 1)
//                            .frame(width: screen_width * 0.52, height: screen_width * 0.12, alignment: .center)
//                            .background(Color(#colorLiteral(red: 0.8541538119, green: 0.5734136701, blue: 0.09998553246, alpha: 1)))
//                            .cornerRadius(15)
//                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 3, x: 2, y: 2)
//                            .labelStyle(HorizontalLabelStyle())
//                    }
//                    .position(x: screen_width * 0.5, y: screen_height * 0.44)

                    
                    chessboardshow.Display(geo_size: CGSize(width: screen_width * 0.65, height: screen_height * 0.65))
                        .position(x: screen_width * 0.675, y: screen_height * 0.9)
                    
                    Text("象棋")
                        .font(.system(size: screen_width * 0.25))
                        .fontWeight(.bold)
                        .foregroundColor(Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)))
                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: 1, y: 1)
                        .shadow(color: Color(#colorLiteral(red: 0.8541538119, green: 0.5734136701, blue: 0.09998553246, alpha: 1)), radius: 10, x: 0, y: 0)
                        .frame(width: screen_width, height: screen_width * 0.25)
                        .position(x: screen_width * 0.5, y: screen_height * 0.2)
                })
                .edgesIgnoringSafeArea(.all)
        }
    }
}
    
//                .navigationBarTitle(Text(""), displayMode: .inline)
//                .navigationBarTitleDisplayMode(.inline)
//                .edgesIgnoringSafeArea(.all)

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
