//
//  PodCastListTableViewCell.swift
//  PodCast
//
//  Created by Ashish Bogati on 13/12/2022.
//

import UIKit
import SDWebImage

class PodCastListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    let podCastImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 3
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    
    
    let episodeCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.text = "Episode Count"
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
        addSubview(trackNameLabel)
        addSubview(artistNameLabel)
        addSubview(episodeCountLabel)

        NSLayoutConstraint.activate([
            podCastImage.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            podCastImage.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            podCastImage.heightAnchor.constraint(equalToConstant: 100),
            podCastImage.widthAnchor.constraint(equalToConstant: 100),

            
            trackNameLabel.topAnchor.constraint(equalTo: podCastImage.topAnchor),
            trackNameLabel.leadingAnchor.constraint(equalTo: podCastImage.trailingAnchor, constant: 12),
            trackNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 2),
            artistNameLabel.leadingAnchor.constraint(equalTo: trackNameLabel.leadingAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: trackNameLabel.trailingAnchor),
            
            episodeCountLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 5),
            episodeCountLabel.leadingAnchor.constraint(equalTo: trackNameLabel.leadingAnchor),
            episodeCountLabel.trailingAnchor.constraint(equalTo: trackNameLabel.trailingAnchor),
        ])
    }
    
    func configureCellData(_ podCast: Podcast) {
        podCastImage.sd_setImage(with: URL(string: podCast.artworkUrl100 ?? "")!)
        trackNameLabel.text = podCast.trackName ?? "No Title"
        artistNameLabel.text = podCast.artistName ?? "No Artist Name"
        var wrapperType = podCast.kind == "podcast" ? "Episode" : "Track"
        if podCast.trackCount ?? 0 > 1 {
            wrapperType += "s"
        }
        episodeCountLabel.text = "\(podCast.trackCount ?? 0) \(wrapperType)"
    }
}
