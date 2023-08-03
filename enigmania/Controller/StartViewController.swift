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
    
    private let lifeColors = ["appLightGreen", "appGreen", "appYellow", "appOrange", "appDarkRed"]
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        layoutSubviews()
        setupSubscriptions()
        livesLabel.isHidden = !GameController.shared.didGameStart.value
        errorImage.alpha = 0.0
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "ENIGMANIA"
        view.font = Helper.getFont().withSize(75)
        view.textColor = .black
        view.applyShadowWith(UIColor(named: "appBlue"))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var playButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "playButton"), for: .normal)
        view.setImage(UIImage(named: "playButton")?.withColor(.green), for: .highlighted)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var titleHStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.addArrangedSubview(titleLabel)
        view.addArrangedSubview(playButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillProportionally
        view.spacing = 75
        
        return view
    }()
    
    private lazy var leftButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "card"), for: .normal)
        view.setTitle("COMEÇAR", for: .normal)
        view.titleLabel?.font = Helper.getFont().withSize(48)
        view.setTitleColor(.black, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didPressLeftButton), for: .touchUpInside)
        
        
        return view
    }()
    
    private lazy var rightButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "card"), for: .normal)
        view.setTitle("TUTORIAL", for: .normal)
        view.titleLabel?.font = Helper.getFont().withSize(48)
        view.setTitleColor(.black, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didPressRightButton), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var buttonHStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.addArrangedSubview(leftButton)
        view.addArrangedSubview(rightButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 75
        view.distribution = .fill
        
        return view
    }()
    
    private lazy var livesLabel: UILabel = {
        let view = UILabel()
        view.text = "VIDAS: \(GameController.shared.lives.value)"
        view.font = Helper.getFont().withSize(32)
        view.textColor = .black
        view.applyShadowWith(UIColor(named: lifeColors[5 - GameController.shared.lives.value]))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var errorImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "errorBackground")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private func addSubviews() {
        view.addSubview(titleHStackView)
        view.addSubview(buttonHStackView)
        view.addSubview(livesLabel)
        view.addSubview(errorImage)
    }
    
    private func layoutSubviews() {
        titleHStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).setActive()
        titleHStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).setActive()
        
        buttonHStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).setActive()
        buttonHStackView.topAnchor.constraint(equalTo: view.centerYAnchor).setActive()
        
        livesLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).setActive()
        livesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).setActive()
        
        errorImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).setActive()
        errorImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).setActive()
    }
    
    @objc
    private func didPressPlayButton() {
        navigationController?.pushViewController(StartViewController(), animated: true)
        GameController.startGame()
    }
    
    @objc
    private func didPressLeftButton() {
        GameController.removeLife()
        GameController.startGame()
        
        // Mostrar a imagem de erro com animação
        UIView.animate(withDuration: 0.5, animations: {
            self.errorImage.alpha = 1.0
        })
        
        // Esconder a imagem de erro após 2 segundos com animação
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.animate(withDuration: 0.5, animations: {
                self.errorImage.alpha = 0.0
            })
        }
        
        
    }
    
    @objc
    private func didPressRightButton() {
        navigationController?.pushViewController(TutorialViewController(), animated: false)
    }
    
    private func updateLivesLabel(_ lives: Int) {
        livesLabel.text = "VIDAS: \(lives)"
        livesLabel.applyShadowWith(UIColor(named: lifeColors[5 - lives]))
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
    }
}

