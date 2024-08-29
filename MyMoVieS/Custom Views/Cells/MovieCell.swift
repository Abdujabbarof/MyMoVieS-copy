//
//  MovieCell.swift
//  MyMoVieS
//
//  Created by Abdulloh on 30/07/24.
//

import UIKit

class MovieCell: UICollectionViewCell {
    static let reuseID = "MovieCell"
    
    let avatarImgView = GFAvatarImgView(frame: .zero)
    let filmLabel = GFTitleLabel(textAlignment: .left, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(film: Film) {
        filmLabel.text = film.nameEn ?? film.nameRu
        avatarImgView.downloadImage(from: film.posterUrl ?? "https://st.kp.yandex.net/images/no-poster.gif")
    }
    
    private func configure() {
        avatarImgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatarImgView)
        addSubview(filmLabel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            avatarImgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding + 10),
            avatarImgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImgView.heightAnchor.constraint(equalTo: avatarImgView.widthAnchor),
            avatarImgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            
            filmLabel.topAnchor.constraint(equalTo: avatarImgView.bottomAnchor, constant: 12),
            filmLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            filmLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            filmLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
}
