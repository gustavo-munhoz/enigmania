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
        errorImage.alpha = 0.0
    }
    
    @objc private func handleTextTap() { GameController.getNextQuestion() }
    
    private lazy var numberLabel: UILabel = {
        let view = UILabel()
        view.text = (GameController.shared.index + 1).description
        view.font = Helper.getFont().withSize(60)
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var questionNumber: UIImageView = {
        let bg = UIImageView(image: UIImage(named: "questionCircle"))
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.addSubview(numberLabel)
            
        return bg
    }()
    
    private lazy var questionText: UILabel = {
        let view = UILabel()
        view.text = GameController.shared.currentQuestion.value.text
        view.font = Helper.getFont().withSize(40)
        view.textColor = .black
        view.minimumScaleFactor = 0.5
        view.adjustsFontSizeToFitWidth = true
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
    
    private lazy var errorImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "errorBackground")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var errorGif: UIImageView?
    
    private func animateErrorImage() {
        do {
            let gif = try UIImage(gifName: "errou.gif")
            self.errorGif = UIImageView(gifImage: gif, loopCount: 2)
            self.errorGif?.translatesAutoresizingMaskIntoConstraints = false
            self.errorImage.addSubview(self.errorGif!)

            errorImage.addSubview(errorGif!)
            
            errorGif!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 390).setActive()
            errorGif!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -290).setActive()
            errorGif!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110).setActive()
            errorGif!.topAnchor.constraint(equalTo: view.topAnchor, constant: 175).setActive()
            
            
            UIView.animate(withDuration: 0.5, animations: {
                self.errorImage.alpha = 1.0
            })

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.errorImage.alpha = 0.0
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.errorGif?.removeFromSuperview()
                }
            }
            
            
        } catch {
            print(error)
        }
    }
    
    private func layoutSubviews() {
        questionNumber.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).setActive()
        questionNumber.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).setActive()
        questionText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).setActive()
        
        questionText.leftAnchor.constraint(equalTo: questionNumber.rightAnchor, constant: 20).setActive()
        questionText.centerYAnchor.constraint(equalTo: questionNumber.centerYAnchor, constant: -16).setActive()
        
        livesLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).setActive()
        livesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).setActive()
        
        questionCollection.topAnchor.constraint(equalTo: questionText.bottomAnchor).setActive()
        questionCollection.bottomAnchor.constraint(equalTo: livesLabel.topAnchor).setActive()
        questionCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).setActive()
        questionCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).setActive()
        
        numberLabel.centerXAnchor.constraint(equalTo: questionNumber.centerXAnchor).setActive()
        numberLabel.centerYAnchor.constraint(equalTo: questionNumber.centerYAnchor).setActive()
        
        errorImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).setActive()
        errorImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).setActive()
    }
    
    private func addSubviews() {
        view.addSubview(questionNumber)
        view.addSubview(questionText)
        view.addSubview(questionCollection)
        view.addSubview(livesLabel)
        view.addSubview(errorImage)
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
        
        GameController.shared.didLoseGame
            .sink {
                if $0 {
                    self.navigationController?.pushViewController(GameOverViewController(), animated: false)
                }
            }
            .store(in: &cancellables)
        
        GameController.shared.didWinGame
            .sink {
                if $0 {
                    self.navigationController?.pushViewController(VictoryViewController(), animated: false)
                }
            }
            .store(in: &cancellables)
        
        GameController.shared.currentQuestion
            .sink { question in
                if GameController.shared.index == 0 {
                    self.questionText.isUserInteractionEnabled = true
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTextTap))
                    self.questionText.addGestureRecognizer(tapGesture)
                } else {
                    self.questionText.isUserInteractionEnabled = false
                    
                    if GameController.shared.index == 14 {
                        self.questionNumber.isUserInteractionEnabled = true
                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTextTap))
                        self.questionNumber.addGestureRecognizer(tapGesture)
                    } else {
                        self.questionNumber.isUserInteractionEnabled = false
                    }
                }
                
                self.questionText.text = GameController.shared.currentQuestion.value.text
                self.numberLabel.text = (GameController.shared.index + 1).description
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
        if GameController.shared.currentQuestion.value.rightIndex?.contains(indexPath.row) ?? false {
            GameController.getNextQuestion()
        }
        else {
            questionCollection.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.questionCollection.isUserInteractionEnabled = true
            }
            
            GameController.removeLife()
            self.animateErrorImage()
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
