//
//  StartViewController.swift
//  enigmania
//
//  Created by Gustavo Munhoz Correa on 03/08/23.
//

import UIKit
import Combine

class StartViewController: UIViewController {
    private let screenHeight = UIScreen.main.bounds.size.height
    private let screenWidth = UIScreen.main.bounds.size.width
    
    private var cancellables = Set<AnyCancellable>()
    
    private var startView = StartView()
    
    override func loadView() {
        view = startView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubscriptions()
        setupButtons()
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setupButtons() {
        startView.handleLeftButtonTap = didPressLeftButton
        startView.handleRightButtonTap = didPressRightButton
        startView.handlePlayButtonTap = didPressPlayButton
    }
    
    
    private func didPressPlayButton() {
        navigationController?.pushViewController(QuizViewController(), animated: false)
        GameController.startGame()
    }
    
    private func didPressLeftButton() {
        GameController.removeLife()
        GameController.startGame()
        
        startView.animateErrorImage()
    }
    
    private func didPressRightButton() {
        navigationController?.pushViewController(TutorialViewController(), animated: false)
    }
        
    private func setupSubscriptions() {
        GameController.shared.lives
            .sink {
                self.startView.updateLivesLabel($0)
            }
            .store(in: &cancellables)
        
        GameController.shared.didGameStart
            .sink {
                self.startView.shouldShowLivesLabel(!$0)
            }
            .store(in: &cancellables)
    }
}

