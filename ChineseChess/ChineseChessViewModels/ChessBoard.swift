//
//  ChessBoard.swift
//  ChineseChess
//
//  Created by 鄭子輿 on 2020/12/21.
//

import SwiftUI
import Foundation

/*
 ( 1,  2) = (將, 帥)
 ( 3,  4) = (士, 仕)
 ( 5,  6) = (象, 相)
 ( 7,  8) = (馬, 傌)
 ( 9, 10) = (車, 俥)
 (11, 12) = (砲, 炮)
 (13, 14) = (卒, 兵)
 */
class ChessBoard: ObservableObject {
    let board_rows: Int = 10
    let board_columns: Int = 9
    
    let board_border_width: CGFloat = 3
    let board_border_offset: CGFloat = 8
    let board_color: Color = Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
    
    let board_line_width: CGFloat = 2
    let board_line_color: Color = Color(#colorLiteral(red: 0.8541538119, green: 0.5734136701, blue: 0.09998553246, alpha: 1))
    
    var geo_height: CGFloat = 0
    var geo_width: CGFloat = 0
    var block_size: CGFloat = 0
    var yoffset: CGFloat = 0
    var xoffset: CGFloat = 0
    
    let chess: Chess = Chess()
    
    @Published var board_top: Int = 0
    @Published var board: [[[Int]]] = [[[Int]]]()
    @Published var chess_ispressed: Bool = false
    @Published var chess_site: (Int, Int) = (-1, -1)
    @Published var checkmate: Bool = false
    @Published var win: Int = 0
    @Published var dead_chess: [[Int]] = [[Int]]()
    
    /*
      1~14 = 正常棋子
     21~34 = 選中棋子
     41~54 = 被吃棋子
     */
    let chess_name: [Int: String] = [
         1: "將",  2: "帥",  3: "士",  4: "仕",  5: "象",  6: "相",  7: "馬",  8: "傌",  9: "車", 10: "俥", 11: "砲", 12: "炮", 13: "卒", 14: "兵",
        21: "將", 22: "帥", 23: "士", 24: "仕", 25: "象", 26: "相", 27: "馬", 28: "傌", 29: "車", 30: "俥", 31: "砲", 32: "炮", 33: "卒", 34: "兵",
        41: "將", 42: "帥", 43: "士", 44: "仕", 45: "象", 46: "相", 47: "馬", 48: "傌", 49: "車", 50: "俥", 51: "砲", 52: "炮", 53: "卒", 54: "兵",
        15: ""]
    
    init() {
        board.append(Array(repeating: Array(repeating: 0, count: board_columns), count: board_rows))
        InitBoard(top: 0)
        dead_chess.append(contentsOf: Array(repeating: Array(repeating: 0, count: 6), count: 2))
    }
    
        // 初始棋盤
    func InitBoard(top: Int) {
        // 卒
        for i in stride(from: 0, through: 8, by: 2) { board[top][3][i] = 13 }
        // 砲
        board[top][2][1] = 11; board[top][2][7] = 11
        // 車
        board[top][0][0] =  9; board[top][0][8] =  9
        // 馬
        board[top][0][1] =  7; board[top][0][7] =  7
        // 象
        board[top][0][2] =  5; board[top][0][6] =  5
        // 士
        board[top][0][3] =  3; board[top][0][5] =  3
        // 將
        board[top][0][4] =  1
        
        // 兵
        for i in stride(from: 0, through: 8, by: 2) { board[top][6][i] = 14 }
        // 炮
        board[top][7][1] = 12; board[top][7][7] = 12
        // 俥
        board[top][9][0] = 10; board[top][9][8] = 10
        // 傌
        board[top][9][1] =  8; board[top][9][7] =  8
        // 相
        board[top][9][2] =  6; board[top][9][6] =  6
        // 仕
        board[top][9][3] =  4; board[top][9][5] =  4
        // 帥
        board[top][9][4] =  2
    }
    
    func SetData(geo_size: CGSize) {
        geo_height = geo_size.height
        geo_width = geo_size.width
        block_size = min(geo_height / CGFloat(board_rows), geo_width / CGFloat(board_columns))
        
        yoffset = (geo_height - CGFloat(board_rows) * block_size + block_size) / 2
        xoffset = (geo_width - CGFloat(board_columns) * block_size + block_size) / 2
    }
    
    // 顯示棋盤
    func Display(geo_size: CGSize) -> some View {
        SetData(geo_size: geo_size)
        
        return ZStack {
            DrawBoardBorder()
            DrawBoardColor()
            DrawBoardBlock()
            DrawBoardLeaderArea()
            DrawBoardRiver()
            DrawBoardCannonPoint()
            DrawBoardSoldierPoint()
            
            chess.Display(chessboard: self)
        }
    }
    
    func DrawBoardBorder() -> some View {
        return Path { path in
            let y: CGFloat = yoffset - board_border_offset - 2
            let x: CGFloat = xoffset - board_border_offset - 2

            path.addRect(CGRect(x: x,
                                y: y,
                                width: block_size * 8 + board_border_offset * 2 + 2,
                                height: block_size * 9 + board_border_offset * 2 + 2))
        }
        .stroke(lineWidth: board_border_width)
        .fill(Color(#colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)))
//        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 2, x: 2, y: 2)
        
    }
    
    func DrawBoardColor() -> some View {
        return VStack {
            Path { path in
                let point1: CGPoint = CGPoint(x: xoffset - board_border_offset + board_border_width / 2 - 2,
                                              y: yoffset - board_border_offset + board_border_width / 2 - 2)
                path.addRect(CGRect(x: point1.x,
                                    y: point1.y,
                                    width: block_size * 8 + board_border_offset * 2 - board_border_width + 2,
                                    height: block_size * 9 + board_border_offset * 2 - board_border_width + 2))
            }
            .fill(board_color)
        }
    }
    
    func DrawBoardBlock() -> some View {
        return Path { path in
            for row in 0..<(board_rows - 1) {
                for col in 0..<(board_columns - 1) {
                    let y = yoffset + block_size * CGFloat(row)
                    let x = xoffset + block_size * CGFloat(col)

                    path.addRect(CGRect(x: x,
                                        y: y,
                                        width: block_size,
                                        height: block_size))
                }
            }

        }
        .stroke(lineWidth: board_line_width)
        .fill(board_line_color)
        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 1, x: -1, y: -1)
    }
    
    func DrawBoardLeaderArea() -> some View {
        return Path { path in
            var point1: CGPoint = CGPoint(x: xoffset + block_size * 3, y: 0)
            var point2: CGPoint = CGPoint(x: xoffset + block_size * 5, y: 0)
            
            point1.y = yoffset
            path.move(to: CGPoint(x: point1.x, y: point1.y))
            point2.y = yoffset + block_size * 2
            path.addLine(to: CGPoint(x: point2.x, y: point2.y))
            
            point1.y = yoffset + block_size * 2
            path.move(to: CGPoint(x: point1.x, y: point1.y))
            point2.y = yoffset
            path.addLine(to: CGPoint(x: point2.x, y: point2.y))
            
            point1.y = yoffset + block_size * 7
            path.move(to: CGPoint(x: point1.x, y: point1.y))
            point2.y = yoffset + block_size * 9
            path.addLine(to: CGPoint(x: point2.x, y: point2.y))
            
            point1.y = yoffset + block_size * 9
            path.move(to: CGPoint(x: point1.x, y: point1.y))
            point2.y = yoffset + block_size * 7
            path.addLine(to: CGPoint(x: point2.x, y: point2.y))
        }
        .stroke(lineWidth: board_line_width)
        .fill(board_line_color)
        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 1, x: -1, y: -1)
    }
    
    func DrawBoardRiver() -> some View {
        return ZStack {
            Path { path in
                let point1: CGPoint = CGPoint(x: xoffset + 1,
                                              y: yoffset + block_size * 4 + 0.8)
                path.addRect(CGRect(x: point1.x,
                                    y: point1.y,
                                    width: block_size * 8 - 4,
                                    height: block_size - 1.5))
            }
            .fill(board_color)
            
            Path { path in
                let point1: CGPoint = CGPoint(x: xoffset + 1,
                                              y: yoffset + block_size * 5)
                let point2: CGPoint = CGPoint(x: xoffset + block_size * 8 - 1,
                                              y: yoffset + block_size * 5)
                
                path.move(to: point1)
                path.addLine(to: point2)
            }
            .stroke(lineWidth: 2)
            .fill(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).opacity(0))
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.6), radius: 0.5, x: 0, y: -1.4)

            Text("楚")
                .font(.system(size: block_size * 0.55))
                .fontWeight(.bold)
                .foregroundColor(board_line_color)
                .rotationEffect(.degrees(270))
                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: -1, y: -1)
                .position(x: xoffset + block_size * 1.5, y: yoffset + block_size * 4.5)
            Text("河")
                .font(.system(size: block_size * 0.55))
                .fontWeight(.bold)
                .foregroundColor(board_line_color)
                .rotationEffect(.degrees(270))
                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: -1, y: -1)
                .position(x: xoffset + block_size * 2.5, y: yoffset + block_size * 4.5)
            Text("界")
                .font(.system(size: block_size * 0.55))
                .fontWeight(.bold)
                .foregroundColor(board_line_color)
                .rotationEffect(.degrees(90))
                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: -1, y: -1)
                .position(x: xoffset + block_size * 5.5, y: yoffset + block_size * 4.5)
            Text("漢")
                .font(.system(size: block_size * 0.55))
                .fontWeight(.bold)
                .foregroundColor(board_line_color)
                .rotationEffect(.degrees(90))
                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius: 0.5, x: -1, y: -1)
                .position(x: xoffset + block_size * 6.5, y: yoffset + block_size * 4.5)
        }
    }
    
    func DrawBoardCannonPoint() -> some View {
        return ZStack {
            DrawBoardPoint(row: 2, col: 1)
            DrawBoardPoint(row: 2, col: 7)
            
            DrawBoardPoint(row: 7, col: 1)
            DrawBoardPoint(row: 7, col: 7)
        }
    }
    
    func DrawBoardSoldierPoint() -> some View {
        return ZStack {
            DrawBoardRightPoint(row: 3, col: 0)
            DrawBoardPoint(row: 3, col: 2)
            DrawBoardPoint(row: 3, col: 4)
            DrawBoardPoint(row: 3, col: 6)
            DrawBoardLeftPoint(row: 3, col: 8)
            
            DrawBoardRightPoint(row: 6, col: 0)
            DrawBoardPoint(row: 6, col: 2)
            DrawBoardPoint(row: 6, col: 4)
            DrawBoardPoint(row: 6, col: 6)
            DrawBoardLeftPoint(row: 6, col: 8)
        }
    }
    
    func DrawBoardPoint(row: Int, col: Int) -> some View {
        let y: CGFloat = yoffset + block_size * CGFloat(row)
        let x: CGFloat = xoffset + block_size * CGFloat(col)
        let line_offset: CGFloat = 5
        let line_width: CGFloat = 1.5
        let line_width_half = line_width / 2
        let line_length: CGFloat = block_size * 0.18
        
        return Path { path in
            var point1: CGPoint = CGPoint()
            var point2: CGPoint = CGPoint()
            
            point1 = CGPoint(x: x - line_offset, y: y - line_offset - line_length + line_width_half)
            point2 = CGPoint(x: x - line_offset, y: y - line_offset + line_width_half)
            path.move(to: point1)
            path.addLine(to: point2)
            
            point1 = CGPoint(x: x - line_offset - line_length + line_width_half, y: y - line_offset)
            point2 = CGPoint(x: x - line_offset + line_width_half, y: y - line_offset)
            path.move(to: point1)
            path.addLine(to: point2)
            
            
            
            point1 = CGPoint(x: x + line_offset, y: y - line_offset - line_length + line_width_half)
            point2 = CGPoint(x: x + line_offset, y: y - line_offset + line_width_half)
            path.move(to: point1)
            path.addLine(to: point2)
            
            point1 = CGPoint(x: x + line_offset + line_length - line_width_half, y: y - line_offset)
            point2 = CGPoint(x: x + line_offset - line_width_half, y: y - line_offset)
            path.move(to: point1)
            path.addLine(to: point2)
            
            
            
            point1 = CGPoint(x: x - line_offset, y: y + line_offset - line_width_half)
            point2 = CGPoint(x: x - line_offset, y: y + line_offset + line_length - line_width_half)
            path.move(to: point1)
            path.addLine(to: point2)
            
            point1 = CGPoint(x: x - line_offset - line_length + line_width_half, y: y + line_offset)
            point2 = CGPoint(x: x - line_offset + line_width_half, y: y + line_offset)
            path.move(to: point1)
            path.addLine(to: point2)
            
            
            
            point1 = CGPoint(x: x + line_offset, y: y + line_offset - line_width_half)
            point2 = CGPoint(x: x + line_offset, y: y + line_offset + line_length - line_width_half)
            path.move(to: point1)
            path.addLine(to: point2)
            
            point1 = CGPoint(x: x + line_offset + line_length - line_width_half, y: y + line_offset)
            point2 = CGPoint(x: x + line_offset - line_width_half, y: y + line_offset)
            path.move(to: point1)
            path.addLine(to: point2)
        }
        .stroke(lineWidth: line_width)
        .fill(board_line_color)
        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(1), radius: 0.5, x: -line_width_half, y: -line_width_half)
    }
    
    func DrawBoardLeftPoint(row: Int, col: Int) -> some View {
        let y: CGFloat = yoffset + block_size * CGFloat(row)
        let x: CGFloat = xoffset + block_size * CGFloat(col)
        let line_offset: CGFloat = 5
        let line_width: CGFloat = 1.5
        let line_width_half = line_width / 2
        let line_length: CGFloat = block_size * 0.18
        
        return Path { path in
            var point1: CGPoint = CGPoint()
            var point2: CGPoint = CGPoint()
            
            point1 = CGPoint(x: x - line_offset, y: y - line_offset - line_length + line_width_half)
            point2 = CGPoint(x: x - line_offset, y: y - line_offset + line_width_half)
            path.move(to: point1)
            path.addLine(to: point2)
            
            point1 = CGPoint(x: x - line_offset - line_length + line_width_half, y: y - line_offset)
            point2 = CGPoint(x: x - line_offset + line_width_half, y: y - line_offset)
            path.move(to: point1)
            path.addLine(to: point2)
            
            
            
            point1 = CGPoint(x: x - line_offset, y: y + line_offset - line_width_half)
            point2 = CGPoint(x: x - line_offset, y: y + line_offset + line_length - line_width_half)
            path.move(to: point1)
            path.addLine(to: point2)
            
            point1 = CGPoint(x: x - line_offset - line_length + line_width_half, y: y + line_offset)
            point2 = CGPoint(x: x - line_offset + line_width_half, y: y + line_offset)
            path.move(to: point1)
            path.addLine(to: point2)
        }
        .stroke(lineWidth: line_width)
        .fill(board_line_color)
        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(1), radius: 0.5, x: -line_width_half, y: -line_width_half)
    }
    
    func DrawBoardRightPoint(row: Int, col: Int) -> some View {
        let y: CGFloat = yoffset + block_size * CGFloat(row)
        let x: CGFloat = xoffset + block_size * CGFloat(col)
        let line_offset: CGFloat = 5
        let line_width: CGFloat = 1.5
        let line_width_half = line_width / 2
        let line_length: CGFloat = block_size * 0.18
        
        return Path { path in
            var point1: CGPoint = CGPoint()
            var point2: CGPoint = CGPoint()
            
            point1 = CGPoint(x: x + line_offset, y: y - line_offset - line_length + line_width_half)
            point2 = CGPoint(x: x + line_offset, y: y - line_offset + line_width_half)
            path.move(to: point1)
            path.addLine(to: point2)
            
            point1 = CGPoint(x: x + line_offset + line_length - line_width_half, y: y - line_offset)
            point2 = CGPoint(x: x + line_offset - line_width_half, y: y - line_offset)
            path.move(to: point1)
            path.addLine(to: point2)
            
            
        
            point1 = CGPoint(x: x + line_offset, y: y + line_offset - line_width_half)
            point2 = CGPoint(x: x + line_offset, y: y + line_offset + line_length - line_width_half)
            path.move(to: point1)
            path.addLine(to: point2)
            
            point1 = CGPoint(x: x + line_offset + line_length - line_width_half, y: y + line_offset)
            point2 = CGPoint(x: x + line_offset - line_width_half, y: y + line_offset)
            path.move(to: point1)
            path.addLine(to: point2)
        }
        .stroke(lineWidth: line_width)
        .fill(board_line_color)
        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(1), radius: 0.5, x: -line_width_half, y: -line_width_half)
    }
    
    // 重新開始
    func Replay() {
        board_top = 0
        
        board.removeAll()
        board.append(Array(repeating: Array(repeating: 0, count: board_columns), count: board_rows))
        InitBoard(top: 0)
        
        chess_ispressed = false
        chess_site = (-1, -1)
        win = 0
        
        dead_chess[0][0] = 5
        dead_chess[1][0] = 5
        for i in 1..<6 {
            dead_chess[0][i] = 2
            dead_chess[1][i] = 2
        }
        for r in 0..<board_rows {
            for c in 0..<board_columns {
                if (abs(board[board_top][r][c]) >= 3) {
                    let dead_chess_value = ((14 - board[board_top][r][c]) >> 1)
                    dead_chess[board[board_top][r][c] & 1][dead_chess_value] -= 1
                }
            }
        }
    }
    
    // 悔棋
    func Regret() {
        if (board_top > 0) {
            board.removeLast()
            board_top -= 1
            
            dead_chess[0][0] = 5
            dead_chess[1][0] = 5
            for i in 1..<6 {
                dead_chess[0][i] = 2
                dead_chess[1][i] = 2
            }
            for r in 0..<board_rows {
                for c in 0..<board_columns {
                    if (abs(board[board_top][r][c]) >= 3) {
                        let dead_chess_value = ((14 - board[board_top][r][c]) >> 1)
                        dead_chess[board[board_top][r][c] & 1][dead_chess_value] -= 1
                    }
                }
            }
        } else {
            print("這是初始棋盤")
        }
        win = 0
    }
    
    // 恢復選擇前棋盤
    func RecoverBoard() {
        for row in 0..<board_rows {
            for col in 0..<board_columns {
                switch board[board_top][row][col] {
                case 15: board[board_top][row][col] = 0
                case 21...34: board[board_top][row][col] -= 20
                case 41...54: board[board_top][row][col] -= 40
                default: continue
                }
            }
        }
    }
    
    // 新增新棋盤
    func NewBoard() {
        if (board_top < 4000) {
            board.append(board[board_top])
            board_top += 1
        } else {
            let last_board = board[board_top]
            board.removeAll()
            board.append(last_board)
            board_top = 0
        }
    }
    
    // 輸出當前棋盤
    func PrintBoard() {
        for row in 0..<board_rows {
            for col in 0..<board_columns {
                print(String(format: "%2d, ", board[board_top][row][col]), terminator: "")
            }
            print()
        }
    }
}
