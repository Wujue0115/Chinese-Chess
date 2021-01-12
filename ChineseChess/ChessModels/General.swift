//
//  General.swift
//  ChineseChess
//
//  Created by 鄭子輿 on 2020/12/28.
//

import Foundation

class General {
    func MoveSite(chessboard: ChessBoard, row: Int, col: Int) {
        let chess_value = chessboard.board[chessboard.board_top][row][col]
        let isRed = (chess_value & 1 == 0 ? true : false)
        // up, down, left, right
        let step: [(Int, Int)] = [(-1, 0), (1, 0), (0, -1), (0, 1)]
        
        for r in stride(from: row + (isRed ? -1 : 1), through: (isRed ? 0 : chessboard.board_rows - 1), by: (isRed ? -1 : 1)) {
            let site_value = chessboard.board[chessboard.board_top][r][col]

            if (site_value == 0) { continue }
            if (site_value != 0 && site_value & 1 == chess_value & 1) { break }
            if (site_value != 1 && site_value != 2) { break }
            
            chessboard.board[chessboard.board_top][r][col] = EatenSite(chess_value: chessboard.board[chessboard.board_top][r][col])
        }
        
        for i in 0..<4 {
            let r = row + step[i].0
            let c = col + step[i].1
            let row_border: (Int, Int) = (isRed ? (7, 9) : (0, 2))
            
            if (r < row_border.0 || r > row_border.1 || c < 3 || c > 5) { continue }
            let site_value = chessboard.board[chessboard.board_top][r][c]
            if (site_value != 0 && site_value & 1 == chess_value & 1) { continue }
            
            chessboard.board[chessboard.board_top][r][c] = EatenSite(chess_value: chessboard.board[chessboard.board_top][r][c])
        }
    }
    
    func Checkmate(chessboard: ChessBoard, row: Int, col: Int) {
        let chess_value = chessboard.board[chessboard.board_top][row][col]
        let isRed = (chess_value & 1 == 0 ? true : false)
        
        for r in stride(from: row + (isRed ? -1 : 1), through: (isRed ? 0 : chessboard.board_rows - 1), by: (isRed ? -1 : 1)) {
            let site_value = chessboard.board[chessboard.board_top][r][col]

            if (site_value == 0) { continue }
            if (site_value != 0 && site_value & 1 == chess_value & 1) { break }
            if (site_value != 1 && site_value != 2) { break }
            
            chessboard.checkmate = true
        }
    }
}
