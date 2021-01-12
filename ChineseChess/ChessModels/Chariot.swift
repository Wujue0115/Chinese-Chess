//
//  Chariot.swift
//  ChineseChess
//
//  Created by 鄭子輿 on 2020/12/28.
//

import Foundation

class Chariot { // 車, 俥
    func MoveSite(chessboard: ChessBoard, row: Int, col: Int) {
        let chess_value = chessboard.board[chessboard.board_top][row][col]
        
        // up
        for r in stride(from: row - 1, through: 0, by: -1) {
            let site_value = chessboard.board[chessboard.board_top][r][col]
            if (site_value != 0){
                if (site_value & 1 != chess_value & 1) {
                    chessboard.board[chessboard.board_top][r][col] = EatenSite(chess_value: site_value)
                }
                break
            }
            chessboard.board[chessboard.board_top][r][col] = 15
        }
        // down
        for r in stride(from: row + 1, to: chessboard.board_rows, by: 1) {
            let site_value = chessboard.board[chessboard.board_top][r][col]
            if (site_value != 0){
                if (site_value & 1 != chess_value & 1) {
                    chessboard.board[chessboard.board_top][r][col] = EatenSite(chess_value: site_value)
                }
                break
            }
            chessboard.board[chessboard.board_top][r][col] = 15
        }
        // left
        for c in stride(from: col - 1, through: 0, by: -1) {
            let site_value = chessboard.board[chessboard.board_top][row][c]
            if (site_value != 0){
                if (site_value & 1 != chess_value & 1) {
                    chessboard.board[chessboard.board_top][row][c] = EatenSite(chess_value: site_value)
                }
                break
            }
            chessboard.board[chessboard.board_top][row][c] = 15
        }
        // right
        for c in stride(from: col + 1, to: chessboard.board_columns, by: 1) {
            let site_value = chessboard.board[chessboard.board_top][row][c]
            if (site_value != 0){
                if (site_value & 1 != chess_value & 1) {
                    chessboard.board[chessboard.board_top][row][c] = EatenSite(chess_value: site_value)
                }
                break
            }
            chessboard.board[chessboard.board_top][row][c] = 15
        }
    }
    
    func Checkmate(chessboard: ChessBoard, row: Int, col: Int) {
        let chess_value = chessboard.board[chessboard.board_top][row][col]
        
        // up
        for r in stride(from: row - 1, through: 0, by: -1) {
            let site_value = chessboard.board[chessboard.board_top][r][col]
            if (site_value != 0){
                if (site_value & 1 != chess_value & 1 && abs(site_value) <= 2) {
                    chessboard.checkmate = true
                }
                break
            }
        }
        // down
        for r in stride(from: row + 1, to: chessboard.board_rows, by: 1) {
            let site_value = chessboard.board[chessboard.board_top][r][col]
            if (site_value != 0){
                if (site_value & 1 != chess_value & 1 && abs(site_value) <= 2) {
                    chessboard.checkmate = true
                }
                break
            }
        }
        // left
        for c in stride(from: col - 1, through: 0, by: -1) {
            let site_value = chessboard.board[chessboard.board_top][row][c]
            if (site_value != 0){
                if (site_value & 1 != chess_value & 1 && abs(site_value) <= 2) {
                    chessboard.checkmate = true
                }
                break
            }
        }
        // right
        for c in stride(from: col + 1, to: chessboard.board_columns, by: 1) {
            let site_value = chessboard.board[chessboard.board_top][row][c]
            if (site_value != 0){
                if (site_value & 1 != chess_value & 1 && abs(site_value) <= 2) {
                    chessboard.checkmate = true
                }
                break
            }
        }
    }
}
