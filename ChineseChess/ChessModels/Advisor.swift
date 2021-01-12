//
//  Advisor.swift
//  ChineseChess
//
//  Created by 鄭子輿 on 2020/12/28.
//

import Foundation

class Advisor {
    func MoveSite(chessboard: ChessBoard, row: Int, col: Int) {
        let chess_value = chessboard.board[chessboard.board_top][row][col]
        let isRed = (chess_value & 1 == 0 ? true : false)
        // left-up, right-up, left-down, right-down
        let step: [(Int, Int)] = [(-1, -1), (-1, 1), (1, -1), (1, 1)]
        
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
}
