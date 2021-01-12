//
//  Chess.swift
//  ChineseChess
//
//  Created by 鄭子輿 on 2020/12/21.
//

import SwiftUI
import Foundation
import AVFoundation

func EatenSite(chess_value: Int) -> Int {
    return chess_value != 0 ? chess_value + 40 : 15
}

/*
 ( 1,  2) = (將, 帥)
 ( 3,  4) = (士, 仕)
 ( 5,  6) = (象, 相)
 ( 7,  8) = (馬, 傌)
 ( 9, 10) = (車, 俥)
 (11, 12) = (砲, 炮)
 (13, 14) = (卒, 兵)
 */

class Chess {
    let chess_color: Color = Color(#colorLiteral(red: 0.869676888, green: 0.6604223847, blue: 0.4165428281, alpha: 1))
    let chess_red_color: Color = Color(#colorLiteral(red: 0.9576502442, green: 0.195281297, blue: 0.08981458098, alpha: 1))
    let chess_black_color: Color = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    let move_color: Color = Color(#colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1))
    
    func Display(chessboard: ChessBoard) -> some View {
        return ZStack {
            DrawAllChess(chessboard: chessboard)
            DrawAllDeadChess(chessboard: chessboard)
        }
    }
    
    func SetMoveSite(chessboard: ChessBoard, row: Int, col: Int) {
        switch chessboard.board[chessboard.board_top][row][col] {
        case 13, 14, 33, 34: Soldier().MoveSite(chessboard: chessboard, row: row, col: col)
        case 11, 12, 31, 32: Cannon().MoveSite(chessboard: chessboard, row: row, col: col)
        case  9, 10, 29, 30: Chariot().MoveSite(chessboard: chessboard, row: row, col: col)
        case  7,  8, 27, 28: House().MoveSite(chessboard: chessboard, row: row, col: col)
        case  5,  6, 25, 26: Elephant().MoveSite(chessboard: chessboard, row: row, col: col)
        case  3,  4, 23, 24: Advisor().MoveSite(chessboard: chessboard, row: row, col: col)
        case  1,  2, 21, 22: General().MoveSite(chessboard: chessboard, row: row, col: col)
        default: return
        }
    }
    
    func FindAllCheckmate(chessboard: ChessBoard) {
        for r in 0..<chessboard.board_rows {
            for c in 0..<chessboard.board_columns {
                if (chessboard.board[chessboard.board_top][r][c] == 0) { continue }
                
                switch chessboard.board[chessboard.board_top][r][c] {
                case 13, 14, 33, 34: Soldier().Checkmate(chessboard: chessboard, row: r, col: c)
                case 11, 12, 31, 32: Cannon().Checkmate(chessboard: chessboard, row: r, col: c)
                case  9, 10, 29, 30: Chariot().Checkmate(chessboard: chessboard, row: r, col: c)
                case  7,  8, 27, 28: House().Checkmate(chessboard: chessboard, row: r, col: c)
                case  1,  2, 21, 22: General().Checkmate(chessboard: chessboard, row: r, col: c)
                default: continue
                }
                
                if (chessboard.checkmate == true) { return }
            }
        }
    }
    
    func DrawAllChess(chessboard: ChessBoard) -> some View {
        return ForEach(0..<chessboard.board_rows) { row in
            ForEach(0..<chessboard.board_columns) { col in
                let chess_value: Int = chessboard.board[chessboard.board_top][row][col]
                if (chess_value != 0) {
                    let y: CGFloat = chessboard.yoffset + CGFloat(row) * chessboard.block_size
                    let x: CGFloat = chessboard.xoffset + CGFloat(col) * chessboard.block_size
                    
                    self.DrawChess(chessboard: chessboard,
                              row: row,
                              col: col,
                              point: CGPoint(x: x, y: y))
                }
            }
        }
    }
    
    func DrawChess(chessboard: ChessBoard, row: Int, col: Int, point: CGPoint) -> some View {
        let chess_value: Int = chessboard.board[chessboard.board_top][row][col]
        let chess_name: String = chessboard.chess_name[chess_value]!
    
        return Button(action: {
            if (chess_value == 15 || (chess_value >= 41 && chess_value <= 54)) {
                chess_place_sound!.play()
                
                chessboard.RecoverBoard()
                chessboard.chess_ispressed.toggle()
                
                // 取得選取棋子位置
                let r = chessboard.chess_site.0
                let c = chessboard.chess_site.1
                
                chessboard.NewBoard()
                chessboard.board[chessboard.board_top][row][col] = chessboard.board[chessboard.board_top - 1][r][c]
                chessboard.board[chessboard.board_top][r][c] = 0
                chessboard.chess_site = (-1, -1)
                
                if (chess_value != 15) {
                    // 判斷勝負
                    if (chess_value == 41) {
                        chessboard.win = 2
                        redwin_sound!.play()
                    }
                    else if (chess_value == 42) {
                        chessboard.win = 1
                        blackwin_sound!.play()
                    }
                    // 計算死棋數量
                    else {
                        let dead_chess = ((54 - chess_value) >> 1)
                        
                        chessboard.dead_chess[chess_value & 1][dead_chess] += 1
                    }
                }
                
                self.FindAllCheckmate(chessboard: chessboard)
                if (chessboard.checkmate == true && chessboard.win == 0) {
                    checkmate_sound!.play()
                }
            }
            else if (chessboard.board_top & 1 == chess_value & 1){
                switch chessboard.board[chessboard.board_top][row][col] {
                case 1...14: // 選取棋子
                    chessboard.RecoverBoard()
                    if (chessboard.chess_ispressed == false) {
                        chessboard.chess_ispressed.toggle()
                    }
                    chessboard.chess_site = (row, col)
                    chessboard.board[chessboard.board_top][row][col] += 20
                    self.SetMoveSite(chessboard: chessboard, row: row, col: col)
                case 21...34: // 取消選取棋子
                    chessboard.chess_ispressed.toggle()
                    chessboard.chess_site = (-1, -1)
                    chessboard.RecoverBoard()
                default: print("chess_value is wrong!")
                }
            }
        }, label: {
            switch chessboard.board[chessboard.board_top][row][col] {
            case 1...14:
                self.ChessTextStyle(chess_value: chessboard.board[chessboard.board_top][row][col],
                                              chess_name: chess_name,
                                              block_size: chessboard.block_size)
            case 15:
                self.ChessMoveSiteStyle(block_size: chessboard.block_size)
            case 21...34:
                self.ChessSelectedTextStyle(chess_value: chessboard.board[chessboard.board_top][row][col],
                                                       chess_name: chess_name,
                                                       block_size: chessboard.block_size)
            case 41...54:
                self.ChessEatenTextStyle(chess_value: chessboard.board[chessboard.board_top][row][col],
                                                    chess_name: chess_name,
                                                    block_size: chessboard.block_size)
            default: Text("")
            }
        })
        .scaleEffect(self.ScaleEffect(chess_value: chess_value))
        .position(point)
        .disabled(chessboard.win != 0 ? true : false)
    }
    
    func ScaleEffect(chess_value: Int) -> CGFloat {
        switch chess_value {
        case 1...15: return 1
        case 21...34: return 1.1
        case 41...54: return 0.9
        default: return 1
        }
    }
    
    func ChessTextStyle(chess_value: Int, chess_name: String, block_size: CGFloat) -> some View {
        return Text(chess_name)
            .font(.system(size: block_size * 0.48))
            .fontWeight(.bold)
            .foregroundColor(chess_value & 1 == 0 ? chess_red_color : chess_black_color)
            .frame(width: block_size * 0.9, height: block_size * 0.9)
            .shadow(color: Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: -1, y: -1)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
            .background(
                Circle()
                    .fill(chess_color)
                    .shadow(color: Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: -1, y: -1)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 1, x: 2, y: 2)
            )
            .overlay(
                Circle()
                    .stroke(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), lineWidth: 2)
                    .frame(width: block_size * 0.9 - 1, height: block_size * 0.9 - 1)
            )
            .overlay(
                Circle()
                    .stroke(chess_value & 1 == 0 ? chess_red_color : chess_black_color, lineWidth: 2)
                    .frame(width: block_size * 0.9 - 9, height: block_size * 0.9 - 9)
                    .shadow(color: Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: -1, y: -1)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
            )
    }
    
    func ChessSelectedTextStyle(chess_value: Int, chess_name: String, block_size: CGFloat) -> some View {
        return Text(chess_name)
            .font(.system(size: block_size * 0.48))
            .fontWeight(.bold)
            .foregroundColor(Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)))
            .frame(width: block_size * 0.9 - 2, height: block_size * 0.9 - 2)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: 1, y: 1)
            .background(
                Circle()
                    .fill(chess_value & 1 == 0 ? chess_red_color : chess_black_color)
                    .shadow(color: Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: -2, y: -2)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.9), radius: 5, x: 8, y: 8)
            )
            .overlay(
                Circle()
                    .stroke(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), lineWidth: 2)
                    .frame(width: block_size * 0.9 - 1, height: block_size * 0.9 - 1)
            )
            
            .overlay(
                Circle().stroke(Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), lineWidth: 2)
                    .frame(width: block_size * 0.9 - 9, height: block_size * 0.9 - 9)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
            )
    }
    
    func ChessEatenTextStyle(chess_value: Int, chess_name: String, block_size: CGFloat) -> some View {
        return Text(chess_name)
            .font(.system(size: block_size * 0.48))
            .fontWeight(.bold)
            .foregroundColor(chess_value & 1 == 0 ? chess_red_color : chess_black_color)
            .frame(width: block_size * 0.9, height: block_size * 0.9)
            .shadow(color: Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: -1, y: -1)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
            .background(
                Circle()
                    .fill(move_color)
                    .opacity(0.8)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 1, x: 3, y: 3)
            )
            .overlay(
                Circle()
                    .stroke(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), lineWidth: 2)
                    .frame(width: block_size * 0.9 - 1, height: block_size * 0.9 - 1)
            )
            .overlay(
                Circle()
                    .stroke(chess_value & 1 == 0 ? chess_red_color : chess_black_color, lineWidth: 2)
                    .frame(width: block_size * 0.9 - 9, height: block_size * 0.9 - 9)
                    .shadow(color: Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: -1, y: -1)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
            )
    }
    
    func ChessMoveSiteStyle(block_size: CGFloat) -> some View {
        return Text(" ")
            .frame(width: block_size * 0.6, height: block_size * 0.6)
            .overlay(
                Circle()
                    .stroke(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), lineWidth: 2)
                    .frame(width: block_size * 0.6, height: block_size * 0.6)
            )
            .background(
                Circle()
                    .fill(move_color)
                    .opacity(0.7)
//                    .shadow(color: Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: -1, y: -1)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 1, x: 3, y: 3)
            )
    }
    
    func DrawAllDeadChess(chessboard: ChessBoard) -> some View {
        let alpha: Double = 0.2
        return ZStack {
            ForEach(0..<6) { i in
                let chess_value = 14 - (i << 1)
                let chess_name = chessboard.chess_name[chess_value]!
                let red_point: CGPoint = CGPoint(x: chessboard.xoffset + chessboard.block_size * 3 + chessboard.block_size * CGFloat(i),
                                                   y: chessboard.yoffset - chessboard.block_size * 1.1)

                self.DrawDeadChess(chess_value: chess_value,
                               chess_name: chess_name,
                               block_size: chessboard.block_size)
                        .position(red_point)
                        .opacity(chessboard.dead_chess[0][i] == 0 ? alpha : 1)
                
                if (chessboard.dead_chess[0][i] != 0) {
                    let point: CGPoint = CGPoint(x: red_point.x + chessboard.block_size * 0.3,
                                                 y: red_point.y - chessboard.block_size * 0.3)
                    self.DrawDeadCounts(chess_value: chess_value, counts: chessboard.dead_chess[0][i], block_size: chessboard.block_size)
                        .position(point)
                }
            }
            ForEach(0..<6) { i in
                let chess_value = 14 - (i << 1) - 1
                let chess_name = chessboard.chess_name[chess_value]!
                let black_point: CGPoint = CGPoint(x: chessboard.xoffset + chessboard.block_size * CGFloat(i),
                                                   y: chessboard.yoffset + chessboard.block_size * 10.1)

                self.DrawDeadChess(chess_value: chess_value,
                                   chess_name: chess_name,
                                   block_size: chessboard.block_size)
                    .position(black_point)
                    .opacity(chessboard.dead_chess[1][i] == 0 ? alpha : 1)
                
                if (chessboard.dead_chess[1][i] != 0) {
                    let point: CGPoint = CGPoint(x: black_point.x + chessboard.block_size * 0.3,
                                                 y: black_point.y - chessboard.block_size * 0.3)
                    self.DrawDeadCounts(chess_value: chess_value, counts: chessboard.dead_chess[1][i], block_size: chessboard.block_size)
                        .position(point)
                }
            }
        }
    }
    
    func DrawDeadChess(chess_value: Int, chess_name: String, block_size: CGFloat) -> some View {
        return Text(chess_name)
            .font(.system(size: block_size * 0.48))
            .fontWeight(.bold)
            .foregroundColor(chess_value & 1 == 0 ? chess_red_color : chess_black_color)
            .frame(width: block_size * 0.9, height: block_size * 0.9)
            .shadow(color: Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: -1, y: -1)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
            .background(
                Circle()
                    .fill(chess_color)
                    .shadow(color: Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: -1, y: -1)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 1, x: 2, y: 2)
            )
            .overlay(
                Circle()
                    .stroke(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), lineWidth: 2)
                    .frame(width: block_size * 0.9 - 1, height: block_size * 0.9 - 1)
            )
            .overlay(
                Circle()
                    .stroke(chess_value & 1 == 0 ? chess_red_color : chess_black_color, lineWidth: 2)
                    .frame(width: block_size * 0.9 - 9, height: block_size * 0.9 - 9)
                    .shadow(color: Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), radius: 0.5, x: -1, y: -1)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: 0.5, y: 0.5)
            )
    }
    
    func DrawDeadCounts(chess_value: Int, counts: Int, block_size: CGFloat) -> some View {
        return Text(String(counts))
            .font(.system(size: block_size * 0.35))
            .fontWeight(.bold)
            .foregroundColor(Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)))
            .frame(width: block_size * 0.4, height: block_size * 0.4)
            .background(
                Circle()
                    .fill(chess_value & 1 == 0 ? chess_red_color : chess_black_color)
                    .shadow(color: chess_value & 1 == 0 ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), radius: 1, x: 0, y: 0)
            )
    }
    
 
    
    
    func oChessTextStyle(chess_value: Int, chess_name: String, block_size: CGFloat) -> some View {
        return Text(chess_name)
            .font(.system(size: block_size * 0.5))
            .fontWeight(.bold)
            .foregroundColor(chess_value & 1 == 0 ? Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
            .frame(width: block_size * 0.9, height: block_size * 0.9)
            .background(
                Circle()
                    .fill(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
            )
            .overlay(
                Circle()
                    .stroke(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), lineWidth: 2)
                    .frame(width: block_size * 0.9 - 1, height: block_size * 0.9 - 1)
            )
            .overlay(
                Circle()
                    .stroke(chess_value & 1 == 0 ? Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), lineWidth: 2)
                    .frame(width: block_size * 0.9 - 9, height: block_size * 0.9 - 9)
            )
    }
    
    func oChessSelectedTextStyle(chess_value: Int, chess_name: String, block_size: CGFloat) -> some View {
        return Text(chess_name)
            .font(.system(size: block_size * 0.5))
            .fontWeight(.bold)
            .foregroundColor(Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)))
            .frame(width: block_size * 0.9, height: block_size * 0.9)
            .background(Circle().fill(chess_value & 1 == 0 ? Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))))
            .overlay(
                Circle()
                .stroke(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), lineWidth: 2)
                .frame(width: block_size * 0.9 - 1, height: block_size * 0.9 - 1)
            )
            .overlay(
                Circle().stroke(Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), lineWidth: 2)
                .frame(width: block_size * 0.9 - 9, height: block_size * 0.9 - 9)
            )
    }
    
    func oChessEatenTextStyle(chess_value: Int, chess_name: String, block_size: CGFloat) -> some View {
        return Text(chess_name)
            .font(.system(size: block_size * 0.5))
            .fontWeight(.bold)
            .foregroundColor(chess_value & 1 == 0 ? Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
            .frame(width: block_size * 0.9, height: block_size * 0.9)
            .background(Circle().fill(move_color))
            .overlay(
                Circle()
                .stroke(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), lineWidth: 2)
                    .frame(width: block_size * 0.9 - 1, height: block_size * 0.9 - 1)
                .overlay(
                    Circle().stroke(chess_value & 1 == 0 ? Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), lineWidth: 2)
                        .frame(width: block_size * 0.9 - 9, height: block_size * 0.9 - 9)
                )
            )
    }
}





