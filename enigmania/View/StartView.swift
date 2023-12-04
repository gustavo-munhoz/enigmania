//
//  StartView.swift
//  enigmania
//
//  Created by Gustavo Munhoz Correa on 04/08/23.
//

import UIKit
import SwiftyGif

class StartView: UIView {
    var handlePlayButtonTap: () -> Void = {}
    var handleLeftButtonTap: () -> Void = {}
    var handleRightButtonTap: () -> Void = {}
    
    let wp = UIScreen.main.bounds.width / 844
    let hp = UIScreen.main.bounds.height / 390
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        configureAdditionalSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.font = UIFontMetrics(forTextStyle: .largeTitle)
            .scaledFont(for: Helper.getFont().withSize(wp * 75))
        
        titleLabel.adjustsFontForContentSizeCategory = true
        
        leftButton.titleLabel?.font = UIFontMetrics(forTextStyle: .body)
            .scaledFont(for: Helper.getFont().withSize(wp * 48))
        
        rightButton.titleLabel?.font = leftButton.titleLabel?.font
        
        livesLabel.font = UIFontMetrics(forTextStyle: .caption1)
            .scaledFont(for: Helper.getFont().withSize(wp * 32))
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ENIGMANIA"
        label.textColor = .black
        label.applyShadowWith(UIColor(named: "appBlue"))
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private lazy var playButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "playButton"), for: .normal)
        view.setImage(UIImage(named: "playButton")?.withColor(.green), for: .highlighted)
        view.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView?.contentMode = .scaleToFill
        view.contentHorizontalAlignment = .fill
        view.contentVerticalAlignment = .fill
        
        return view
    }()
    
    private lazy var titleHStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.addArrangedSubview(titleLabel)
        view.addArrangedSubview(playButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillProportionally
        view.alignment = .center
        view.spacing = 75 * wp
        
        return view
    }()
    
    private lazy var leftButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "card"), for: .normal)
        view.setTitle("COMEÇAR", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.addTarget(self, action: #selector(didPressLeftButton), for: .touchUpInside)
        view.imageView?.contentMode = .scaleToFill
        view.titleLabel?.adjustsFontSizeToFitWidth = true
        
        return view
    }()
    
    private lazy var rightButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "card"), for: .normal)
        view.setTitle("TUTORIAL", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.addTarget(self, action: #selector(didPressRightButton), for: .touchUpInside)
        view.imageView?.contentMode = .scaleToFill
        view.titleLabel?.adjustsFontSizeToFitWidth = true
        
        return view
    }()
    
    private lazy var buttonHStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.addArrangedSubview(leftButton)
        view.addArrangedSubview(rightButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 75 * wp
        
        return view
    }()
    
    private lazy var livesLabel: UILabel = {
        let view = UILabel()
        view.text = "VIDAS: \(GameController.shared.lives.value)"
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
    
    private func addSubviews() {
        addSubview(titleHStackView)
        addSubview(buttonHStackView)
        addSubview(livesLabel)
        addSubview(errorImage)
    }
    
    private func setupConstraints() {
        titleHStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: wp * 172).setActive()
        let ct = titleHStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -wp * 165)
        ct.priority = UILayoutPriority(999)
        ct.setActive()
        
        titleHStackView.topAnchor.constraint(equalTo: topAnchor, constant: wp * 10).setActive()
        
        buttonHStackView.centerXAnchor.constraint(equalTo: centerXAnchor).setActive()
        buttonHStackView.topAnchor.constraint(equalTo: centerYAnchor).setActive()
        
        livesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: wp * -20).setActive()
        livesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: wp * 20).setActive()
        
        errorImage.centerXAnchor.constraint(equalTo: centerXAnchor).setActive()
        errorImage.centerYAnchor.constraint(equalTo: centerYAnchor).setActive()
        errorImage.leadingAnchor.constraint(equalTo: leadingAnchor).setActive()
        errorImage.trailingAnchor.constraint(equalTo: trailingAnchor).setActive()
        errorImage.heightAnchor.constraint(equalTo: errorImage.widthAnchor, multiplier: 181.6/856.6).setActive()
        
        playButton.widthAnchor.constraint(equalToConstant: wp * 44).setActive()
        playButton.heightAnchor.constraint(equalTo: playButton.widthAnchor, multiplier: 44/43).setActive()
        
        leftButton.widthAnchor.constraint(equalToConstant: wp * 340).setActive()
        leftButton.heightAnchor.constraint(equalToConstant: hp * 98).setActive()
        
        rightButton.widthAnchor.constraint(equalTo: leftButton.widthAnchor).setActive()
        rightButton.heightAnchor.constraint(equalTo: leftButton.heightAnchor).setActive()
        
        layoutIfNeeded()
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
        do {
            self.leftButton.isUserInteractionEnabled = false
            let gif = try UIImage(gifName: "errou.gif")
            self.errorGif = UIImageView(gifImage: gif, loopCount: 2)
            self.errorGif?.translatesAutoresizingMaskIntoConstraints = false
            self.errorImage.addSubview(self.errorGif!)

            errorImage.addSubview(errorGif!)
            
            errorGif!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: wp * -290).setActive()
            errorGif!.topAnchor.constraint(equalTo: topAnchor, constant: hp * 175).setActive()
            errorGif!.widthAnchor.constraint(equalToConstant: wp * 91).setActive()
            errorGif!.heightAnchor.constraint(equalTo: errorGif!.widthAnchor, multiplier: 91/79).setActive()
            
            
            UIView.animate(withDuration: 0.5, animations: {
                self.errorImage.alpha = 1.0
            })

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.errorImage.alpha = 0.0
                    self.leftButton.isUserInteractionEnabled = true
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.errorGif?.removeFromSuperview()
                }
            }
            
            
        } catch {
            print(error)
        }
    }

    
    func updateLivesLabel(_ lives: Int) {
        livesLabel.text = "VIDAS: \(lives)"
        livesLabel.applyShadowWith(UIColor(named: Helper.lifeColors[5 - lives]))
    }
    
    func shouldShowLivesLabel(_ value: Bool) {
        livesLabel.isHidden = !value
    }
}
