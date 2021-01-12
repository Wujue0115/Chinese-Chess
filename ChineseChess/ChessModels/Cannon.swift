//
//  Cannon.swift
//  ChineseChess
//
//  Created by 鄭子輿 on 2020/12/28.
//

import Foundation


class Cannon { // 砲, 炮
    func MoveSite(chessboard: ChessBoard, row: Int, col: Int) {
        let chess_value = chessboard.board[chessboard.board_top][row][col]
        
        var i: Int = 0
        // up
        i = row - 1
        while (i >= 0 && chessboard.board[chessboard.board_top][i][col] == 0) {
            chessboard.board[chessboard.board_top][i][col] = 15
            i -= 1
        }
        for r in stride(from: i - 1, through: 0, by: -1) {
            let site_value = chessboard.board[chessboard.board_top][r][col]
            if (site_value != 0){
                if (site_value & 1 != chess_value & 1) {
                    chessboard.board[chessboard.board_top][r][col] = EatenSite(chess_value: site_value)
                }
                break
            }
        }
        // down
        i = row + 1
        while (i < chessboard.board_rows && chessboard.board[chessboard.board_top][i][col] == 0) {
            chessboard.board[chessboard.board_top][i][col] = 15
            i += 1
        }
        for r in stride(from: i + 1, to: chessboard.board_rows, by: 1) {
            let site_value = chessboard.board[chessboard.board_top][r][col]
            if (site_value != 0){
                if (site_value & 1 != chess_value & 1) {
                    chessboard.board[chessboard.board_top][r][col] = EatenSite(chess_value: site_value)
                }
                break
            }
        }
        // left
        i = col - 1
        while (i >= 0 && chessboard.board[chessboard.board_top][row][i] == 0) {
            chessboard.board[chessboard.board_top][row][i] = 15
            i -= 1
        }
        for c in stride(from: i - 1, through: 0, by: -1) {
            let site_value = chessboard.board[chessboard.board_top][row][c]
            if (site_value != 0){
                if (site_value & 1 != chess_value & 1) {
                    chessboard.board[chessboard.board_top][row][c] = EatenSite(chess_value: site_value)
                }
                break
            }
        }
        // right
        i = col + 1
        while (i < chessboard.board_columns && chessboard.board[chessboard.board_top][row][i] == 0) {
            chessboard.board[chessboard.board_top][row][i] = 15
            i += 1
        }
        for c in stride(from: i + 1, to: chessboard.board_columns, by: 1) {
            let site_value = chessboard.board[chessboard.board_top][row][c]
            if (site_value != 0){
                if (site_value & 1 != chess_value & 1) {
                    chessboard.board[chessboard.board_top][row][c] = EatenSite(chess_value: site_value)
                }
                break
            }
        }
    }
    
    
    func Checkmate(chessboard: ChessBoard, row: Int, col: Int) {
        let chess_value = chessboard.board[chessboard.board_top][row][col]
        
        var i: Int = 0
        // up
        i = row - 1
        while (i >= 0 && chessboard.board[chessboard.board_top][i][col] == 0) {
            i -= 1
        }
        for r in stride(from: i - 1, through: 0, by: -1) {
            let site_value = chessboard.board[chessboard.board_top][r][col]
            if (site_value != 0){
                if (site_value & 1 != chess_value & 1 && abs(site_value) <= 2) {
                    chessboard.checkmate = true
                }
                break
            }
        }
        // down
        i = row + 1
        while (i < chessboard.board_rows && chessboard.board[chessboard.board_top][i][col] == 0) {
            i += 1
        }
        for r in stride(from: i + 1, to: chessboard.board_rows, by: 1) {
            let site_value = chessboard.board[chessboard.board_top][r][col]
            if (site_value != 0){
                if (site_value & 1 != chess_value & 1 && abs(site_value) <= 2) {
                    chessboard.checkmate = true
                }
                break
            }
        }
        // left
        i = col - 1
        while (i >= 0 && chessboard.board[chessboard.board_top][row][i] == 0) {
            i -= 1
        }
        for c in stride(from: i - 1, through: 0, by: -1) {
            let site_value = chessboard.board[chessboard.board_top][row][c]
            if (site_value != 0){
                if (site_value & 1 != chess_value & 1 && abs(site_value) <= 2) {
                    chessboard.checkmate = true
                }
                break
            }
        }
        // right
        i = col + 1
        while (i < chessboard.board_columns && chessboard.board[chessboard.board_top][row][i] == 0) {
            i += 1
        }
        for c in stride(from: i + 1, to: chessboard.board_columns, by: 1) {
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
