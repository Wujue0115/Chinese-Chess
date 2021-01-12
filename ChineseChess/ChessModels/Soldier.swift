//
//  Soldier.swift
//  ChineseChess
//
//  Created by 鄭子輿 on 2020/12/28.
//

import Foundation

class Soldier { // 卒, 兵
    func MoveSite(chessboard: ChessBoard, row: Int, col: Int) {
        let chess_value = chessboard.board[chessboard.board_top][row][col]
        // up, left, right, down
        let step: [(Int, Int)] = [(-1, 0), (0, -1), (0, 1), (1, 0)]
        
        if (chess_value & 1 == 0) { // red
            for i in 0..<(row >= 5 ? 1 : 3) {
                let r = row + step[i].0
                let c = col + step[i].1
                if (r < 0 || r >= chessboard.board_rows || c < 0 || c >= chessboard.board_columns) { continue }
                let site_value = chessboard.board[chessboard.board_top][r][c]
                if (site_value != 0 && site_value & 1 == chess_value & 1) { continue }
                
                chessboard.board[chessboard.board_top][r][c] = EatenSite(chess_value: chessboard.board[chessboard.board_top][r][c])
            }
        } else { // black
            for i in (row <= 4 ? 3 : 1)..<4 {
                let r = row + step[i].0
                let c = col + step[i].1
                if (r < 0 || r >= chessboard.board_rows || c < 0 || c >= chessboard.board_columns) { continue }
                let site_value = chessboard.board[chessboard.board_top][r][c]
                if (site_value != 0 && site_value & 1 == chess_value & 1) { continue }
                
                chessboard.board[chessboard.board_top][r][c] = EatenSite(chess_value: chessboard.board[chessboard.board_top][r][c])
            }
        }
    }
    
    func Checkmate(chessboard: ChessBoard, row: Int, col: Int) {
        let chess_value = chessboard.board[chessboard.board_top][row][col]
        // up, left, right, down
        let step: [(Int, Int)] = [(-1, 0), (0, -1), (0, 1), (1, 0)]
        
        if (chess_value & 1 == 0) { // red
            for i in 0..<(row >= 5 ? 1 : 3) {
                let r = row + step[i].0
                let c = col + step[i].1
                if (r < 0 || r >= chessboard.board_rows || c < 0 || c >= chessboard.board_columns) { continue }
                let site_value = chessboard.board[chessboard.board_top][r][c]
                if (site_value != 0 && site_value & 1 == chess_value & 1) { continue }
                if (site_value != 1 && site_value != 2) { continue }
                
                chessboard.checkmate = true
            }
        } else { // black
            for i in (row <= 4 ? 3 : 1)..<4 {
                let r = row + step[i].0
                let c = col + step[i].1
                if (r < 0 || r >= chessboard.board_rows || c < 0 || c >= chessboard.board_columns) { continue }
                let site_value = chessboard.board[chessboard.board_top][r][c]
                if (site_value != 0 && site_value & 1 == chess_value & 1) { continue }
                if (site_value != 1 && site_value != 2) { continue }
                
                chessboard.checkmate = true
            }
        }
    }
}
