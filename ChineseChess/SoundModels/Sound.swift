//
//  Sound.swift
//  ChineseChess
//
//  Created by 鄭子輿 on 2021/1/6.
//

import Foundation
import AVFoundation

//let chess_place_sound = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "PlaceSound", withExtension: "mp3")!)
let chess_place_sound = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "PlaceSound2", withExtension: "wav")!)

let checkmate_sound = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Checkmate", withExtension: "mp3")!)

let redwin_sound = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "RedWin", withExtension: "mp3")!)
let blackwin_sound = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "BlackWin", withExtension: "mp3")!)


