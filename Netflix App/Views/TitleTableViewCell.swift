//
//  TitleTableViewCell.swift
//  Netflix App
//
//  Created by Cumulations on 09/06/23.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    static let indentifier = "TitleTableViewCell"
    
    private let playTitleButton : UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titlesPosterUIIMageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private func applyConstraints() {
            
        let titlesPosterUIIMageViewConstraints = [
            titlesPosterUIIMageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlesPosterUIIMageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titlesPosterUIIMageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titlesPosterUIIMageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titleLabelConstraintsConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: titlesPosterUIIMageView.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        
        ]
        
        let playTitleButtonConstraints = [
            playTitleButton.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
            
        NSLayoutConstraint.activate(titlesPosterUIIMageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraintsConstraints)
        NSLayoutConstraint.activate(playTitleButtonConstraints)
    }
    
    public func configure(with model: TitleViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            return
        }
        titlesPosterUIIMageView.sd_setImage(with: url)
        titleLabel.text = model.titleName
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlesPosterUIIMageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
