//
//  PlayerView.swift
//  PodCast
//
//  Created by Ashish Bogati on 15/12/2022.
//

import UIKit
import SDWebImage
import Combine
import SnapKit

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
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
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
    
    let audioSliderView = AudioSliderView()
    let playerControl = PlayerControlView()
    let soundControl = SoundControlView()
    let playerViewModel = PlayerViewModel()
    
    // MARK: - Methods
    init(frame: CGRect = .zero, episode: Episode) {
        self.episode = episode
        super.init(frame: frame)
        setupViews()
        loadData()
        playerViewModel.streamURL = episode.streamURL
        observeViewModel()
        observeAlbumArtEnlarge()
        observerTimeStamp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        backgroundColor = .secondarySystemBackground
        
        dismissButton.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        playerControl.playButton.addTarget(playerViewModel, action: #selector(playerViewModel.play), for: .touchUpInside)
        audioSliderView.playerSlider.addTarget(self, action: #selector(handleCurrentTimeSliderChange), for: .valueChanged)
        
        addSubview(stackView)
        stackView.addArrangedSubview(dismissButton)
        stackView.addArrangedSubview(albumArtImageView)
        stackView.addArrangedSubview(audioSliderView)
        stackView.addArrangedSubview(trackNameLabel)
        stackView.addArrangedSubview(authorLabel)
        
        stackView.addArrangedSubview(playerControl)
        stackView.addArrangedSubview(soundControl)
    
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        soundControl.snp.makeConstraints { make in
            make.height.equalTo(34)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        audioSliderView.snp.makeConstraints { make in
            make.height.equalTo(75)
        }
        
        albumArtImageView.snp.makeConstraints { make in
            make.height.equalTo(albumArtImageView.snp.width).multipliedBy(1.0)
        }
        
        trackNameLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        soundControl.snp.makeConstraints { make in
            make.height.equalTo(34)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(50)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self).offset(-20)
        }
    }
    
    fileprivate func loadData() {
        albumArtImageView.sd_setImage(with: URL(string: episode.image ?? ""))
        trackNameLabel.text = episode.title ?? "No Title"
        authorLabel.text = episode.author ?? ""
        animateAlbumArtImageView()
    }
    
    fileprivate func animateAlbumArtImageView(scale: CGFloat = 0.7) {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            if scale == 0 {
                self.albumArtImageView.transform = .identity
            } else {
                self.albumArtImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
    }
    
    fileprivate func observeViewModel() {
        playerViewModel.$isPlaying.receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                let image = status == true ? UIImage(named: "pause") : UIImage(named: "play")
                self?.playerControl.playButton.setImage(image, for: .normal)
            }.store(in: &subscriptions)
    }
    
    fileprivate func observeAlbumArtEnlarge() {
        playerViewModel.$isEnlargeEpisode.receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                if status == true {
                    self?.animateAlbumArtImageView(scale: 0.0)
                } else {
                    self?.animateAlbumArtImageView()
                }
            }.store(in: &subscriptions)
    }
    
    fileprivate func observerTimeStamp() {
        playerViewModel.$currentPlayingTime.receive(on: DispatchQueue.main)
            .sink { [weak self] time in
                self?.audioSliderView.currentPlayingTimeLabel.text = time
            }.store(in: &subscriptions)
        
        playerViewModel.$totalTimeValue.receive(on: DispatchQueue.main)
            .sink { [weak self] time in
                self?.audioSliderView.totalPlayingTimeLabel.text = time
            }.store(in: &subscriptions)
        
        playerViewModel.$currentPlayingTimeSlider.receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.audioSliderView.playerSlider.value = value
            }.store(in: &subscriptions)
        
        playerViewModel.$currentBufferValue.receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.audioSliderView.bufferProgress.progress = value
            }.store(in: &subscriptions)
    }
    
    // MARK: - Actions
    @objc
    func didTapDismiss() {
        self.removeFromSuperview()
    }
    
    @objc
    func handleCurrentTimeSliderChange(_ sender: UISlider) {
        playerViewModel.handleSliderValueChange(sender.value)
    }
}

protocol PlayerViewFactory {
    func makePlayerView(episode: Episode) -> PlayerView
}
