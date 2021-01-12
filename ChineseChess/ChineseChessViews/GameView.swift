//
//  GameView.swift
//  ChineseChess
//
//  Created by 鄭子輿 on 2020/12/21.
//

import SwiftUI
import AVFoundation

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var backAlert = false
    @State private var isBack = false
    
    init() {
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = UIColor(Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)))
        UINavigationBar.appearance().standardAppearance = barAppearance
    }
    
    var body: some View {
        ZStack {
            ChessBoardView()
        }
        .background(LinearGradient(
                        gradient: Gradient(colors:[Color(#colorLiteral(red: 1, green: 0.9766529202, blue: 0.7833630443, alpha: 1))]),
                        startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                NavigationLink(destination: ContentView()) {
                    Button(action: {
                        self.backAlert = true
                        }, label: {
                            Label("返回", systemImage: "chevron.backward.circle.fill")
                                .font(.system(size: screen_width * 0.055, weight: .bold))
                                .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                                .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 3, x: 0, y: 0)
                        }
                    )
                    .alert(isPresented: $backAlert) {
                        Alert(title: Text("確定返回？"),
                              message: Text("注意：返回後原本的棋局記錄將消失！"),
                              primaryButton: .default(Text("取消")),
                              secondaryButton: .default(Text("確定"), action: {
                                  self.presentationMode.wrappedValue.dismiss()
                              })
                        )
                    }
                }
//            , trailing:
//                NavigationLink(destination: TestView()) {
//                    Button(action: {
//                        self.presentationMode.wrappedValue.dismiss()
//                        }, label: {
//                            Label("設定", systemImage: "gearshape.fill")
//                                .font(.system(size: screen_width * 0.06, weight: .bold))
//                                .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
//                                .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 3, x: 0, y: 0)
//                                .labelStyle(HorizontalLabelStyle())
//                        }
//                    )
//                }
        )
//        .navigationBarItems(
//            trailing:
//                NavigationLink(destination: TestView()) {
//                    Button(action: {
//                        self.presentationMode.wrappedValue.dismiss()
//                        }, label: {
//                            Label("設定", systemImage: "gearshape.fill")
//                                .font(.system(size: screen_width * 0.06, weight: .bold))
//                                .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
//                                .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 3, x: 0, y: 0)
//                                .labelStyle(HorizontalLabelStyle())
//                        }
//                    )
//                }
//        )
        
        
//        .navigationBarTitle(Text(""), displayMode: .inline)
//        .navigationBarHidden(true)
//        .edgesIgnoringSafeArea(.all)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct HorizontalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}
