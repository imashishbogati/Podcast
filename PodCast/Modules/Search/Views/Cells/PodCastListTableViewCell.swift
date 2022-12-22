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
        image.layer.cornerRadius = 3
        return image
    }()
    
    let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 3
        label.textColor = .label
        return label
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    
    let episodeCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
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
        
        podCastImage.snp.makeConstraints { make in
            make.top.equalTo(self).offset(8)
            make.leading.equalTo(self).offset(16)
            make.width.equalTo(100)
            make.height.equalTo(podCastImage.snp.height)
        }
        
        trackNameLabel.snp.makeConstraints { make in
            make.top.equalTo(podCastImage.snp.top)
            make.leading.equalTo(podCastImage.snp.trailing).offset(12)
            make.trailing.equalTo(self).offset(-12)
        }
        
        artistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(trackNameLabel.snp.bottom).offset(2)
            make.leading.equalTo(trackNameLabel.snp.leading)
            make.trailing.equalTo(trackNameLabel.snp.trailing)
        }
        
        episodeCountLabel.snp.makeConstraints { make in
            make.top.equalTo(artistNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(trackNameLabel.snp.leading)
            make.trailing.equalTo(trackNameLabel.snp.trailing)
        }
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
