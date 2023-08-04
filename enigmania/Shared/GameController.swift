//
//  GameController.swift
//  enigmania
//
//  Created by Gustavo Munhoz Correa on 03/08/23.
//

import Combine

class GameController {
    static let shared = GameController()
    
    private(set) var tries: Int
    private(set) var lives: CurrentValueSubject<Int, Never>
    private(set) var didGameStart: CurrentValueSubject<Bool, Never>
    private(set) var currentQuestion: CurrentValueSubject<Question, Never>
    private(set) var index: Int
    
    private(set) var questions: [Question] = [
        Question(
            text: "Aperte na resposta.",
            alternatives: ["A resposta", "Resposta", "A Resposta", "resposta"],
            rightIndex: 0
        ),
        Question(
            text: "Qual é a origem do \"Sim!\"?",
            alternatives: ["Sim!", "Sim?", "Não!", "NÃO SEI?"],
            rightIndex: 3
        ),
        Question(
            text: "Quantos anéis tem Saturno?",
            alternatives: ["mais do que dá pra contar", "2", "983", "Anel? Eu mal consigo pagar o aluguel."],
            rightIndex: 3
        ),
        Question(
            text: "Qual é a cor do unicórnio invisível?",
            alternatives: ["Azul", "Rosa", "Transparente", "O quê?"],
            rightIndex: 3
        ),
        Question(
            text: "O que um peixe faria em uma árvore?",
            alternatives: ["Escalar", "Nadar", "einstein?", "Ele não estaria lá em primeiro lugar."],
            rightIndex: 2
        ),
        Question(
            text: "O que você faz quando não faz nada?",
            alternatives: ["Descansar", "Pensar", "Ficar entediado", "Cadê meu relógio?"],
            rightIndex: 3
        ),
        Question(
            text: "Por que abreviação é uma palavra tão longa?",
            alternatives: ["Por que é irônico", "Não há motivo", "Para confundir as pessoas", "PQS"],
            rightIndex: 3
        ),
        Question(
            text: "O oposto de oposto é o mesmo ou oposto?",
            alternatives: ["O mesmo", "Oposto", "Depende do contexto", "Do oposto ou do mesm0?"],
            rightIndex: 3
        ),
        Question(
            text: "O que faz uma sucuri agiota?",
            alternatives: ["Comer", "Rastejar", "Cobrar", "Sussurrar"],
            rightIndex: 2
        ),
        Question(
            text: "Quem mora em Tilambuco é...",
            alternatives: ["1", "1 mano", "1 galo", "1 vaca"],
            rightIndex: 1
        ),
        Question(
            text: "Qual é a sexta letra do alfabeto?",
            alternatives: ["A", "B", "C", "E"],
            rightIndex: 3
        ),
        Question(
            text: "O que cobre a resposta?",
            alternatives: ["A pergunta", "Uma capa", "Seu dedo", "Um cobertor"],
            rightIndex: 2
        ),
        Question(
            text: "▴▴▴",
            alternatives: ["▲", "▼", "►", "◄"],
            rightIndex: 0
        ),
        Question(
            text: "Quantas letras em arara?",
            alternatives: ["5", "2", "6", "4"],
            rightIndex: 1
        ),
        Question(
            text: "7 + 8 = ?",
            alternatives: ["15", "14", "16", "Número da pergunta"],
            rightIndex: 3
        )
    ]
    
    private init() {
        lives = CurrentValueSubject(5)
        tries = 0
        didGameStart = CurrentValueSubject(false)
        currentQuestion = CurrentValueSubject(self.questions[0])
        index = 0
    }
    
    static func getNextQuestion() {
        guard self.shared.index > self.shared.questions.count else {
            self.shared.index += 1
            self.shared.currentQuestion.value = self.shared.questions[self.shared.index]
            return
        }
        self.shared.currentQuestion.value = self.shared.questions[self.shared.questions.count - 1]
    }
    
    static func removeLife() {
        if shared.lives.value > 1 { shared.lives.value -= 1 }
    }
    
    static func startGame() {
        shared.didGameStart.value = true
    }
}
