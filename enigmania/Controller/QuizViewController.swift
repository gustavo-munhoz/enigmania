//
//  QuizViewController.swift
//  enigmania
//
//  Created by Gustavo Munhoz Correa on 03/08/23.
//

import UIKit
import Combine

class QuizViewController: UIViewController {
    private let screenHeight = UIScreen.main.bounds.size.height
    private let screenWidth = UIScreen.main.bounds.size.width
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        addSubviews()
        layoutSubviews()
        setupSubscriptions()
    }
    
    private lazy var questionNumber: UIImageView = {
        let view = UILabel()
        view.text = "\(GameController.shared.index + 1)"
        view.font = Helper.getFont().withSize(60)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let bg = UIImageView(image: UIImage(named: "questionCircle"))
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.addSubview(view)
        
        view.centerXAnchor.constraint(equalTo: bg.centerXAnchor).setActive()
        view.centerYAnchor.constraint(equalTo: bg.centerYAnchor).setActive()
        
        return bg
    }()
    
    private lazy var questionText: UILabel = {
        let view = UILabel()
        view.text = GameController.shared.currentQuestion.value.text
        view.font = Helper.getFont().withSize(40)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var questionCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        var view = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(QuestionViewCell.self, forCellWithReuseIdentifier: QuestionViewCell.identifier)
        return view
    }()
    
    private lazy var livesLabel: UILabel = {
        let view = UILabel()
        view.text = "VIDAS: \(GameController.shared.lives.value)"
        view.font = Helper.getFont().withSize(32)
        view.textColor = .black
        view.applyShadowWith(UIColor(named: Helper.lifeColors[5 - GameController.shared.lives.value]))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private func layoutSubviews() {
        questionNumber.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).setActive()
        questionNumber.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).setActive()
        
        questionText.leftAnchor.constraint(equalTo: questionNumber.rightAnchor, constant: 20).setActive()
        questionText.centerYAnchor.constraint(equalTo: questionNumber.centerYAnchor, constant: -16).setActive()
        
        livesLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).setActive()
        livesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).setActive()
        
        questionCollection.topAnchor.constraint(equalTo: questionText.bottomAnchor).setActive()
        questionCollection.bottomAnchor.constraint(equalTo: livesLabel.topAnchor).setActive()
        questionCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).setActive()
        questionCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).setActive()
    }
    
    private func addSubviews() {
        view.addSubview(questionNumber)
        view.addSubview(questionText)
        view.addSubview(questionCollection)
        view.addSubview(livesLabel)
    }
    
    private func updateLivesLabel(_ lives: Int) {
        livesLabel.text = "VIDAS: \(lives)"
        livesLabel.applyShadowWith(UIColor(named: Helper.lifeColors[5 - lives]))
    }
    
    private func setupSubscriptions() {
        GameController.shared.lives
            .sink {
                self.updateLivesLabel($0)
            }
            .store(in: &cancellables)
        
        GameController.shared.didGameStart
            .sink {
                self.livesLabel.isHidden = !$0
            }
            .store(in: &cancellables)
        
        GameController.shared.currentQuestion
            .sink { question in
                self.questionText.text = GameController.shared.currentQuestion.value.text
                self.questionCollection.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension QuizViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestionViewCell.identifier, for: indexPath) as? QuestionViewCell else { return UICollectionViewCell() }
        cell.setupView(text: GameController.shared.currentQuestion.value.alternatives[indexPath.row])
        return cell
    }
}

extension QuizViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if GameController.shared.currentQuestion.value.rightIndex == indexPath.row {
            GameController.getNextQuestion()
        } else {
            GameController.removeLife()
        }
    }
}

extension QuizViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
