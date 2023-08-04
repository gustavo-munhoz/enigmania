//
//  StartView.swift
//  enigmania
//
//  Created by Gustavo Munhoz Correa on 04/08/23.
//

import UIKit

class StartView: UIView {
    var handlePlayButtonTap: () -> Void = {}
    var handleLeftButtonTap: () -> Void = {}
    var handleRightButtonTap: () -> Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        configureAdditionalSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func addSubviews() {
        addSubview(titleHStackView)
        addSubview(buttonHStackView)
        addSubview(livesLabel)
        addSubview(errorImage)
    }
    
    private func setupConstraints() {
        titleHStackView.centerXAnchor.constraint(equalTo: centerXAnchor).setActive()
        titleHStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).setActive()
        
        buttonHStackView.centerXAnchor.constraint(equalTo: centerXAnchor).setActive()
        buttonHStackView.topAnchor.constraint(equalTo: centerYAnchor).setActive()
        
        livesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).setActive()
        livesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).setActive()
        
        errorImage.centerXAnchor.constraint(equalTo: centerXAnchor).setActive()
        errorImage.centerYAnchor.constraint(equalTo: centerYAnchor).setActive()
    }
    
    private func configureAdditionalSettings() {
        backgroundColor = .white
        livesLabel.isHidden = !GameController.shared.didGameStart.value
        errorImage.alpha = 0.0
    }
    
    @objc
    private func didPressPlayButton() {
        handlePlayButtonTap()
    }
    
    @objc
    private func didPressLeftButton() {
        handleLeftButtonTap()
    }
    
    @objc
    private func didPressRightButton() {
        handleRightButtonTap()
    }
    
    func animateErrorImage() {
        UIView.animate(withDuration: 0.5, animations: {
            self.errorImage.alpha = 1.0
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.animate(withDuration: 0.5, animations: {
                self.errorImage.alpha = 0.0
            })
        }
    }
    
    func updateLivesLabel(_ lives: Int) {
        livesLabel.text = "VIDAS: \(lives)"
        livesLabel.applyShadowWith(UIColor(named: Helper.lifeColors[5 - lives]))
    }
    
    func shouldShowLivesLabel(_ value: Bool) {
        livesLabel.isHidden = value
    }
}
