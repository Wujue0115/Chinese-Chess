//
//  ChessBoardView.swift
//  ChineseChess
//
//  Created by 鄭子輿 on 2020/12/25.
//

import SwiftUI
import AVFoundation

struct ChessBoardView: View {
    @StateObject private var chessboard: ChessBoard = ChessBoard()
    @State private var replayAlert: Bool = false
    @State private var checkmateRemaining = 2
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    init() {
        chess_place_sound!.volume = 8
        
        checkmate_sound!.enableRate = true
        checkmate_sound!.rate = 1.5
        
        redwin_sound!.enableRate = true
        blackwin_sound!.enableRate = true
        redwin_sound!.rate = 2.8
        blackwin_sound!.rate = 2.8
    }
    
    var body: some View {
        GeometryReader { (geo: GeometryProxy) in
            self.RoundText(geo_size: geo.size)
            self.ReplayLabel(geo_size: geo.size)
            self.RegretLabel(geo_size: geo.size)
            
            chessboard.Display(geo_size: geo.size)
            
            if (chessboard.checkmate == true) {
                self.CheckmateText(geo_size: geo.size)
            }
        }
    }
    
    func RoundText(geo_size: CGSize) -> some View {
        return Text(chessboard.win == 0 ?
                        (chessboard.board_top & 1 == 0 ? "紅方回合" : "黑方回合") :
                        (chessboard.win & 1 == 0 ? "紅方勝利" : "黑方勝利")
        )
            .font(.system(size: geo_size.width * 0.07))
            .fontWeight(.bold)
            .foregroundColor(Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)))
            .shadow(color: Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: -0.5, y: -0.5)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: 1, y: 1)
            .shadow(color: Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), radius: 10, x: 0, y: 0)
            .frame(width: geo_size.width * 0.4, height: geo_size.width * 0.1)
            .background(chessboard.win == 0 ?
                        (chessboard.board_top & 1 == 0 ? Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))) :
                        (chessboard.win & 1 == 0 ? Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
            )
            .cornerRadius(15)
            .shadow(color: Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), radius: 3, x: 2, y: 2)
            .scaleEffect(chessboard.win == 0 ? 1 : 1.4)
            .position(x: geo_size.width * 0.5, y: screen_height * 0.07)
    }
    
    func ReplayLabel(geo_size: CGSize) -> some View {
        return Button(action: {
//            chessboard.Replay()
            self.replayAlert = true
        }) {
            Label("重玩", systemImage: "arrow.counterclockwise.circle.fill")
            .font(.system(size: geo_size.width * 0.06, weight: .bold))
            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            .shadow(color: Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: -0.5, y: -0.5)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: 1, y: 1)
            .frame(width: geo_size.width * 0.28, height: geo_size.width * 0.09)
            .background(Color(#colorLiteral(red: 0.8541538119, green: 0.5734136701, blue: 0.09998553246, alpha: 1)))
            .cornerRadius(15)
            .shadow(color: Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), radius: 3, x: 2, y: 2)
            .position(x: geo_size.width * 0.3, y: geo_size.height * 0.91)
//            .onTapGesture {
//               chessboard.Replay()
//            }
        }
        .alert(isPresented: $replayAlert) {
            Alert(title: Text("確定重玩？"),
                  message: Text("注意：重玩後原本的棋局記錄將消失！"),
                  primaryButton: .default(Text("取消")),
                  secondaryButton: .default(Text("確定"), action: {
                      chessboard.Replay()
                  })
            )
        }
    }
    
    func RegretLabel(geo_size: CGSize) -> some View {
        return Label("悔棋", systemImage: "arrow.uturn.backward.circle.fill")
            .font(.system(size: geo_size.width * 0.06, weight: .bold))
            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            .shadow(color: Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: -0.5, y: -0.5)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: 1, y: 1)
            .frame(width: geo_size.width * 0.28, height: geo_size.width * 0.09)
            .background(Color(#colorLiteral(red: 0.8541538119, green: 0.5734136701, blue: 0.09998553246, alpha: 1)))
            .cornerRadius(15)
            .shadow(color: Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)), radius: 3, x: 2, y: 2)
            .position(x: geo_size.width * 0.7, y: geo_size.height * 0.91)
            .onTapGesture {
                chessboard.Regret()
            }
    }
    
    func CheckmateText(geo_size: CGSize) -> some View {
        return Text("將軍")
            .font(.system(size: geo_size.width * 0.3))
            .fontWeight(.bold)
            .foregroundColor(Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)))
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: 1, y: 1)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 10, x: 0, y: 0)
            .frame(width: geo_size.width * 0.3, height: geo_size.width * 0.75)
            .position(x: geo_size.width * 0.5, y: geo_size.height * 0.5)
            .onReceive(timer, perform: { _ in
                guard (chessboard.checkmate == true) else { return }
                if (checkmateRemaining == 0) {
                    chessboard.checkmate = false
                    checkmateRemaining = 2
                }
                checkmateRemaining -= 1
            })
    }
}


struct ChessBoardView_Previews: PreviewProvider {
    static var previews: some View {
//        Group {
            ChessBoardView()
//        }
            //.previewLayout(.fixed(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
}
