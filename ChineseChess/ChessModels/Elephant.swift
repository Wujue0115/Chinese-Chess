//
//  Elephant.swift
//  ChineseChess
//
//  Created by 鄭子輿 on 2020/12/28.
//

import Foundation

class Elephant {
    func MoveSite(chessboard: ChessBoard, row: Int, col: Int) {
        let chess_value = chessboard.board[chessboard.board_top][row][col]
        let isRed = (chess_value & 1 == 0 ? true : false)
        // left-up, right-up, left-down, right-down
        let step: [(Int, Int)] = [(-1, -1), (-1, 1), (1, -1), (1, 1)]
        
        for i in 0..<4 {
            var r = row + step[i].0
            var c = col + step[i].1
            
            if (r < (isRed ? 5 : 0) || r >= (isRed ? chessboard.board_rows : 5) ||
                c < 0 || c >= chessboard.board_columns) {
                continue
            }
            
            if (chessboard.board[chessboard.board_top][r][c] == 0) {
                r += step[i].0
                c += step[i].1
                
                if (r < (isRed ? 5 : 0) || r >= (isRed ? chessboard.board_rows : 5) ||
                    c < 0 || c >= chessboard.board_columns) {
                    continue
                }
                let site_value = chessboard.board[chessboard.board_top][r][c]
                if (site_value != 0 && site_value & 1 == chess_value & 1) { continue }
                
                chessboard.board[chessboard.board_top][r][c] = EatenSite(chess_value: chessboard.board[chessboard.board_top][r][c])
            }
        }
    }
}
