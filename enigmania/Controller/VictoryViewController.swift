//
//  VictoryViewController.swift
//  enigmania
//
//  Created by Gustavo Munhoz Correa on 07/08/23.
//

import UIKit

class VictoryViewController: UIViewController {
    private lazy var backgroundView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "victory")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var playAgainButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "playAgainWin"), for: .normal)
        view.addTarget(self, action: #selector(loseGameInstantly), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var smileButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "SMILE"), for: .normal)
        view.setImage(UIImage(named: "SMILE")?.withColor(.green), for: .highlighted)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(handlePlayAgainTap), for: .touchUpInside)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
        
        GameController.playSound("vitoria", ofType: "mp3", shouldRepeat: true)
        addSubviews()
        layoutSubviews()
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
        
        view.addSubview(smileButton)
    }
    
    private func layoutSubviews() {
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).setActive()
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).setActive()
        
        playAgainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).setActive()
        playAgainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).setActive()
        
        smileButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40).setActive()
        smileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).setActive()
    }
    
    @objc func handlePlayAgainTap() {
        navigationController?.popToRootViewController(animated: false)
    }
    
    @objc func loseGameInstantly() {
        navigationController?.pushViewController(GameOverViewController(), animated: false)
    }
}
