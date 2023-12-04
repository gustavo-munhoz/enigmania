//
//  QuestionViewCell.swift
//  enigmania
//
//  Created by Gustavo Munhoz Correa on 04/08/23.
//

import UIKit

class QuestionViewCell: UICollectionViewCell {
    static let identifier = "QuestionViewCell"
    
    let wp = UIScreen.main.bounds.width / 844
    let hp = UIScreen.main.bounds.height / 390
    
    private lazy var cardImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "card")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var cardText: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = UIFontMetrics(forTextStyle: .largeTitle)
            .scaledFont(for: Helper.getFont().withSize(wp * 36))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.minimumScaleFactor = 0.5
        view.adjustsFontSizeToFitWidth = true
        view.numberOfLines = 0
        
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        cardImage.addSubview(cardText)
        addSubview(cardImage)
    }
    
    private func setupConstraints() {
        cardImage.centerXAnchor.constraint(equalTo: centerXAnchor).setActive()
        cardImage.centerYAnchor.constraint(equalTo: centerYAnchor).setActive()
        cardImage.widthAnchor.constraint(equalToConstant: cardImage.image!.size.width * wp).setActive()
        cardImage.heightAnchor.constraint(equalToConstant: cardImage.image!.size.height * wp).setActive()
        
        cardText.topAnchor.constraint(equalTo: cardImage.topAnchor, constant: wp * 12).setActive()
        cardText.bottomAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: wp * -12).setActive()
        cardText.leadingAnchor.constraint(equalTo: cardImage.leadingAnchor, constant: wp * 12).setActive()
        cardText.trailingAnchor.constraint(equalTo: cardImage.trailingAnchor, constant: wp * -12).setActive()
        
    }
    
    func setupView(text: String) {
        cardText.text = text
    }
}
