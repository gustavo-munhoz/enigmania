//
//  GameController.swift
//  enigmania
//
//  Created by Gustavo Munhoz Correa on 03/08/23.
//

import Combine
import AVFoundation

class GameController {
    static let shared = GameController()
    static private var audioPlayer: AVAudioPlayer?
    
    private(set) var tries: Int
    private(set) var lives: CurrentValueSubject<Int, Never>
    private(set) var didGameStart: CurrentValueSubject<Bool, Never>
    private(set) var didLoseGame: CurrentValueSubject<Bool, Never>
    private(set) var didWinGame: CurrentValueSubject<Bool, Never>
    private(set) var currentQuestion: CurrentValueSubject<Question, Never>
    private(set) var index: Int
    
    private(set) var questions: [Question] = [
        Question(
            text: "Aperte na resposta.",
            alternatives: ["A resposta", "Resposta", "A Resposta", "resposta"],
            rightIndex: []
        ),
        Question(
            text: "Qual a origem do \"Sim!\"?",
            alternatives: ["OPERATIONAL SYSTEM", "Papanduva", "Não!", "NÃO SEI?"],
            rightIndex: [0]
        ),
        Question(
            text: "Quantos anéis tem Saturno?",
            alternatives: ["mais do que dá pra contar", "2", "983", "Anel? Eu mal consigo pagar o aluguel."],
            rightIndex: [3]
        ),
        Question(
            text: "Qual é a cor do unicórnio invisível?",
            alternatives: ["Azul", "Rosa", "Invisível", "O quê?"],
            rightIndex: [3]
        ),
        Question(
            text: "Por que abreviação é uma palavra tão longa?",
            alternatives: ["Ironia", "Não tem motivo", "Confundir pessoas", "PQS"],
            rightIndex: [3]
        ),
        Question(
            text: "O oposto de oposto é o mesmo ou oposto?",
            alternatives: ["O mesmo", "Oposto", "Questão de referência", "Do oposto ou do mesmo?"],
            rightIndex: [2]
        ),
        Question(
            text: "Qual é a sexta letra do alfabeto?",
            alternatives: ["F", "G", "C", "E"],
            rightIndex: [3]
        ),
        Question(
            text: "O que cobre a resposta?",
            alternatives: ["A pergunta", "Uma capa", "Um dedo", "Um cobertor"],
            rightIndex: [2]
        ),
        Question(
            text: "L1 L2 R1 R2",
            alternatives: ["↑ ↓ ← →", "← ◼︎ ▲ ↑", " ✕ ▲ ↑ ↓ ", "→ ◼︎ ● ←"],
            rightIndex: [0]
        ),
        Question(
            text: "Quantas letras em arara?",
            alternatives: ["5", "2", "6", "4"],
            rightIndex: [1]
        ),
        Question(
            text: "O que é melhor?",
            alternatives: ["Matemática", "História", "Biologia", "Química"],
            rightIndex: [0]
        ),
        Question(
            text: "Nirvana culinário:",
            alternatives: ["nuggets", "sashimi", "churrasco", "coxinha"],
            rightIndex: [0, 1]
        ),
        Question(
            text: "Qual é a resposta correta?",
            alternatives: ["ESSA", "ESTA", "ESSA AQUI", "ESTA AQUI"],
            rightIndex: [0, 1, 2, 3]
        ),
        Question(
            text: "Qual o pior lugar?",
            alternatives: ["GULAG", "CATIVEIRO", "BANHEIRO QUÍMICO", "FESTA COM GENTE AMONTOADA"],
            rightIndex: [3]
        ),
        Question(
            text: "7 + 8 = ?",
            alternatives: ["treze", "catorze", "dez e seis", "quatorze"],
            rightIndex: []
        ),
    ]
    
    private init() {
        lives = CurrentValueSubject(5)
        tries = 0
        didGameStart = CurrentValueSubject(false)
        didLoseGame = CurrentValueSubject(false)
        didWinGame = CurrentValueSubject(false)
        currentQuestion = CurrentValueSubject(self.questions[0])
        index = 0
    }
    
    static func playSound(_ soundName: String, ofType type: String) {
        if let path = Bundle.main.path(forResource: soundName, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("Sound file not found: \(soundName)")
            }
        }
    }
    
    static func playSound(_ soundName: String, ofType type: String, shouldRepeat r: Bool) {
        if let path = Bundle.main.path(forResource: soundName, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                if r {
                    audioPlayer?.numberOfLoops = -1
                }
                audioPlayer?.play()
            } catch {
                print("Sound file not found: \(soundName)")
            }
        }
    }
    
    
    
    static func getNextQuestion() {
        playSound("acertou", ofType: "mp3")
        self.shared.index += 1
        guard self.shared.index > self.shared.questions.count - 1 else {
            self.shared.currentQuestion.value = self.shared.questions[self.shared.index]
            return
        }
        shared.didWinGame.value = true
    }
    
    static func removeLife() {
        if shared.lives.value > 1 {
            shared.lives.value -= 1
            playSound("errou-aud", ofType: "wav")
        } else {
            shared.didLoseGame.value = true
        }
        
    }
    
    static func startGame() {
        shared.didGameStart.value = true
    }
    
    static func resetGame() {
        shared.lives = CurrentValueSubject(5)
        shared.tries += 1
        shared.didGameStart = CurrentValueSubject(false)
        shared.didLoseGame = CurrentValueSubject(false)
        shared.didWinGame = CurrentValueSubject(false)
        shared.currentQuestion = CurrentValueSubject(shared.questions[0])
        shared.index = 0
    }
}
