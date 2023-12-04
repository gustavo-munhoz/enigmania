//
//  TutorialViewController.swift
//  enigmania
//
//  Created by Gustavo Munhoz Correa on 03/08/23.
//

import UIKit

class TutorialViewController: UIViewController {

    let wp = UIScreen.main.bounds.width / 844
    let hp = UIScreen.main.bounds.height / 390
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tutorialView)
        view.addSubview(okButton)
        navigationItem.setHidesBackButton(true, animated: false)
        NSLayoutConstraint.activate([
            tutorialView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tutorialView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: wp * -50),
            tutorialView.widthAnchor.constraint(equalToConstant: wp * 844),
            tutorialView.heightAnchor.constraint(equalToConstant: hp * 390 * 0.6),
            okButton.centerXAnchor.constraint(equalTo: tutorialView.centerXAnchor),
            okButton.topAnchor.constraint(equalTo: tutorialView.bottomAnchor, constant: hp * 10)
        ])
    }
    
    private lazy var tutorialView: UILabel = {
        let view = UILabel()
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        view.textAlignment = .center
        view.text = "CLIQUE NAS RESPOSTAS CORRETAS."
        view.font = Helper.getFont().withSize(wp * 60)
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontSizeToFitWidth = true

        return view
    }()
    
    private lazy var okButton: UIButton = {
        let view = UIButton()
        view.setTitle("OK.", for: .normal)
        view.titleLabel?.font = Helper.getFont().withSize(wp * 40)
        view.setTitleColor(.black, for: .normal)
        view.addTarget(self, action: #selector(didPressOk), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "okButton"), for: .normal)
        view.titleLabel?.adjustsFontSizeToFitWidth = true
        
        return view
    }()
    
    @objc
    private func didPressOk() {
        navigationController?.popViewController(animated: false)
    }
}
