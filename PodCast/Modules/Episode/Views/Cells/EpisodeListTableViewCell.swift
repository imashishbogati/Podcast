//
//  EpisodeListTableViewCell.swift
//  PodCast
//
//  Created by Ashish Bogati on 14/12/2022.
//

import UIKit
import SDWebImage
import SnapKit

class EpisodeListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    let podCastImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 3
        return image
    }()
    
    let weekDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .purple
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 3
        label.textColor = .label
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
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
        
        podCastImage.snp.makeConstraints { make in
            make.top.equalTo(self).offset(8)
            make.leading.equalTo(self).offset(16)
            make.height.equalTo(100)
            make.width.equalTo(100)
            make.trailing.equalTo(weekDayLabel.snp.leading).offset(-12)
        }
        
        weekDayLabel.snp.makeConstraints { make in
            make.top.equalTo(podCastImage.snp.top)
            make.trailing.equalTo(self).offset(-12)
            make.leading.equalTo(podCastImage.snp.trailing).offset(12)
        }
        
        trackNameLabel.snp.makeConstraints { make in
            make.top.equalTo(weekDayLabel.snp.bottom)
            make.trailing.equalTo(self).offset(-12)
            make.leading.equalTo(podCastImage.snp.trailing).offset(12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(trackNameLabel.snp.bottom)
            make.bottom.equalTo(self).offset(-10)
            make.trailing.equalTo(self).offset(-12)
            make.leading.equalTo(podCastImage.snp.trailing).offset(12)
        }
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
