//
//  House.swift
//  ChineseChess
//
//  Created by 鄭子輿 on 2020/12/28.
//

import Foundation

class House {
    func MoveSite(chessboard: ChessBoard, row: Int, col: Int) {
        let chess_value = chessboard.board[chessboard.board_top][row][col]
        // up, down, left, right
        let step1: [(Int, Int)] = [(-1, 0), (1, 0), (0, -1), (0, 1)]
        let step2: [(Int, Int)] = [(-1, -1), (-1, 1), (1, -1), (1, 1), (-1, -1), (1, -1), (-1, 1), (1, 1)]
        
        for i in 0..<4 {
            let m = row + step1[i].0
            let n = col + step1[i].1
            
            if (m < 0 || m >= chessboard.board_rows || n < 0 || n >= chessboard.board_columns) { continue }
            if (chessboard.board[chessboard.board_top][m][n] != 0) { continue }
            
            let a = i << 1
            let b = (i << 1) + 1
            for j in a...b {
                let r = m + step2[j].0
                let c = n + step2[j].1
                
                if (r < 0 || r >= chessboard.board_rows || c < 0 || c >= chessboard.board_columns) { continue }
                let site_value = chessboard.board[chessboard.board_top][r][c]
                if (site_value != 0 && site_value & 1 == chess_value & 1) { continue }
                
                chessboard.board[chessboard.board_top][r][c] = EatenSite(chess_value: chessboard.board[chessboard.board_top][r][c])
            }
        }
    }
    
    func Checkmate(chessboard: ChessBoard, row: Int, col: Int) {
        let chess_value = chessboard.board[chessboard.board_top][row][col]
        // up, down, left, right
        let step1: [(Int, Int)] = [(-1, 0), (1, 0), (0, -1), (0, 1)]
        let step2: [(Int, Int)] = [(-1, -1), (-1, 1), (1, -1), (1, 1), (-1, -1), (1, -1), (-1, 1), (1, 1)]
        
        for i in 0..<4 {
            let m = row + step1[i].0
            let n = col + step1[i].1
            
            if (m < 0 || m >= chessboard.board_rows || n < 0 || n >= chessboard.board_columns) { continue }
            if (chessboard.board[chessboard.board_top][m][n] != 0) { continue }
            
            let a = i << 1
            let b = (i << 1) + 1
            for j in a...b {
                let r = m + step2[j].0
                let c = n + step2[j].1
                
                if (r < 0 || r >= chessboard.board_rows || c < 0 || c >= chessboard.board_columns) { continue }
                let site_value = chessboard.board[chessboard.board_top][r][c]
                if (site_value != 0 && site_value & 1 == chess_value & 1) { continue }
                if (site_value != 1 && site_value != 2) { continue }
                
                chessboard.checkmate = true
            }
        }
    }
}
