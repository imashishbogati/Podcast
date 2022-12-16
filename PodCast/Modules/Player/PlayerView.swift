//
//  PlayerView.swift
//  PodCast
//
//  Created by Ashish Bogati on 15/12/2022.
//

import UIKit
import SDWebImage

import Combine

class PlayerView: UIView {
    
    // MARK: - Properties
    var episode: Episode
    
    private var subscriptions = Set<AnyCancellable>()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("Dismiss", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.setTitleColor(.link, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    lazy var albumArtImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "appicon")
        view.contentMode = .scaleAspectFit
        view.sd_setImage(with: URL(string: episode.image ?? ""))
        return view
    }()
    
    let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 2
        label.text = "Episode Title"
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
        label.text = "Author Label"
        label.textAlignment = .center
        label.textColor = .purple
        return label
    }()
    
    let playerControllerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    let rewindButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rewind15"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play"), for: .normal)
        button.addTarget(playerViewModel, action: #selector(playerViewModel.play), for: .touchUpInside)
        button.tintColor = .label
        return button
    }()
    
    let forwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "fastforward15"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    
    let playerSlider: UISlider = {
        let slider = UISlider()
        return slider
    }()
    
    let currentPlayingTimeLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12)
        label.text = "00:00:00"
        return label
    }()
    
    let totalPlayingTimeLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .secondaryLabel
        label.textAlignment = .right
        label.text = "88:88:88"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    let timeStampStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fill
        view.axis = .horizontal
        return view
    }()
    
    let volumControlStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        return view
    }()
    
    let muteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "muted_volume"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    let maxVolumeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "max_volume"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    let volumeSlider: UISlider = {
        let slider = UISlider()
        return slider
    }()

    
    
    let playerViewModel = PlayerViewModel()
    
    // MARK: - Methods
    init(frame: CGRect = .zero, episode: Episode) {
        self.episode = episode
        super.init(frame: frame)
        setupViews()
        loadData()
        playerViewModel.streamURL = episode.streamURL
        observeViewModel()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        backgroundColor = .secondarySystemBackground
        
        dismissButton.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        
        addSubview(stackView)
        stackView.addArrangedSubview(dismissButton)
        stackView.addArrangedSubview(albumArtImageView)
        stackView.addArrangedSubview(playerSlider)
        stackView.addArrangedSubview(timeStampStackView)
        stackView.addArrangedSubview(trackNameLabel)
        stackView.addArrangedSubview(authorLabel)
        
        stackView.addArrangedSubview(playerControllerStackView)
        stackView.addArrangedSubview(volumControlStackView)
        
        
        playerControllerStackView.addArrangedSubview(rewindButton)
        playerControllerStackView.addArrangedSubview(playButton)
        playerControllerStackView.addArrangedSubview(forwardButton)
        
        volumControlStackView.addArrangedSubview(muteButton)
        volumControlStackView.addArrangedSubview(volumeSlider)
        volumControlStackView.addArrangedSubview(maxVolumeButton)
        
        
        timeStampStackView.addArrangedSubview(currentPlayingTimeLabel)
        timeStampStackView.addArrangedSubview(totalPlayingTimeLabel)
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            
            dismissButton.heightAnchor.constraint(equalToConstant: 44),
            playerSlider.heightAnchor.constraint(equalToConstant: 35),
            timeStampStackView.heightAnchor.constraint(equalToConstant: 40),
            
            albumArtImageView.heightAnchor.constraint(equalTo: albumArtImageView.widthAnchor, multiplier: 1.0/1.0),
            
            trackNameLabel.heightAnchor.constraint(equalToConstant: 20),
            authorLabel.heightAnchor.constraint(equalToConstant: 20),
            volumControlStackView.heightAnchor.constraint(equalToConstant: 34),
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }
    
    fileprivate func loadData() {
        trackNameLabel.text = episode.title ?? "No Title"
        authorLabel.text = episode.author ?? ""
    }
    
    
    fileprivate func observeViewModel() {
        playerViewModel.$isPlaying.receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                let image = status == true ? UIImage(named: "pause") : UIImage(named: "play")
                self?.playButton.setImage(image, for: .normal)
            }.store(in: &subscriptions)
    }
    
    // MARK: - Actions
    @objc
    func didTapDismiss() {
        self.removeFromSuperview()
    }
    
//    @objc
//    func didTapPlayButton() {
//
//    }
}


protocol PlayerViewFactory {
    func makePlayerView(episode: Episode) -> PlayerView
}
