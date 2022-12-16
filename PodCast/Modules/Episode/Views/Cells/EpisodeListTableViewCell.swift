//
//  EpisodeListTableViewCell.swift
//  PodCast
//
//  Created by Ashish Bogati on 14/12/2022.
//

import UIKit
import SDWebImage

class EpisodeListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    let podCastImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 3
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let weekDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .purple
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        styleViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func styleViews() {
        addSubview(podCastImage)
        addSubview(weekDayLabel)
        addSubview(trackNameLabel)
        addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            podCastImage.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            podCastImage.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            podCastImage.heightAnchor.constraint(equalToConstant: 100),
            podCastImage.widthAnchor.constraint(equalToConstant: 100),
            podCastImage.trailingAnchor.constraint(equalTo: weekDayLabel.leadingAnchor, constant: -12),
            
            weekDayLabel.topAnchor.constraint(equalTo: podCastImage.topAnchor),
            weekDayLabel.leadingAnchor.constraint(equalTo: podCastImage.trailingAnchor, constant: 12),
            weekDayLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            trackNameLabel.topAnchor.constraint(equalTo: weekDayLabel.bottomAnchor, constant: 4),
            trackNameLabel.leadingAnchor.constraint(equalTo: podCastImage.trailingAnchor, constant: 12),
            trackNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            descriptionLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: podCastImage.trailingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configureCell(episode: Episode, image: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        weekDayLabel.text = dateFormatter.string(from: episode.lastBuildDate!)
        trackNameLabel.text = episode.title ?? ""
        descriptionLabel.text = episode.descriptions?.toPlainText() ?? ""
        let imageURL = URL(string: episode.image != nil ? episode.image?.toSecureHTTPS() ?? "" : image)
        podCastImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "appicon"))
    }
}
