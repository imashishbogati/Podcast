//
//  FavoriteCollectionViewCell.swift
//  PodCast
//
//  Created by Ashish Bogati on 22/12/2022.
//

import UIKit
import SDWebImage
import SnapKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properites
    let podCastImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 3
        image.image = UIImage(named: "appicon")
        return image
    }()
    
    let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 3
        label.text = "DUMMY"
        label.textColor = .label
        return label
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        label.text = "NPL"
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupStackViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    fileprivate func setupStackViews() {
        addStackViewSubViews(views: podCastImage, trackNameLabel, artistNameLabel)
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        podCastImage.snp.makeConstraints { make in
            make.height.equalTo(podCastImage.snp.width)
        }
        
    }
    
    fileprivate func addStackViewSubViews(views: UIView...) {
        for view in views {
            stackView.addArrangedSubview(view)
        }
    }
    
    func configureCellData(podCast: Podcast) {
        podCastImage.sd_setImage(with: URL(string: podCast.artworkUrl100 ?? "")!)
        trackNameLabel.text = podCast.trackName ?? "No Title"
        artistNameLabel.text = podCast.artistName ?? "No Artist Name"
    }
    
}
