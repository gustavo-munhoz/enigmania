//
//  GameController.swift
//  enigmania
//
//  Created by Gustavo Munhoz Correa on 03/08/23.
//

import Combine

class GameController {
    static let shared = GameController()
    
    private(set) var lives: CurrentValueSubject<Int, Never>
    private(set) var tries: Int
    private(set) var didGameStart: CurrentValueSubject<Bool, Never>
    
    private init() {
        lives = CurrentValueSubject(5)
        tries = 0
        didGameStart = CurrentValueSubject(false)
    }
    
    static func removeLife() {
        if shared.lives.value > 1 { shared.lives.value -= 1 }
    }
    
    static func startGame() {
        shared.didGameStart.value = true
    }
}
