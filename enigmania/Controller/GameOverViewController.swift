//
//  GameOverViewController.swift
//  enigmania
//
//  Created by Gustavo Munhoz Correa on 07/08/23.
//

import UIKit

class GameOverViewController: UIViewController {
    private lazy var backgroundView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "gameOver")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var playAgainButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "playAgain"), for: .normal)
        view.addTarget(self, action: #selector(handlePlayAgainTap), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
        
        addSubviews()
        layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MusicPlayer.shared.stopBackgroundMusic()
        GameController.playSound("explosion", ofType: "mp3")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        GameController.resetGame()
    }
    
    private func addSubviews() {
        view.addSubview(backgroundView)
        view.addSubview(playAgainButton)
        
        playAgainButton.alpha = 0
        UIView.animate(withDuration: 3, animations: {
            self.playAgainButton.alpha = 1.0
        })
    }
    
    private func layoutSubviews() {
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).setActive()
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).setActive()
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).setActive()
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).setActive()
        
        playAgainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).setActive()
        playAgainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).setActive()
    }
    
    @objc func handlePlayAgainTap() {
        MusicPlayer.shared.startBackgroundMusic()
        navigationController?.popToRootViewController(animated: false)
    }
}
