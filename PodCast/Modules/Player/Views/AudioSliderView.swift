//
//  AudioSlider.swift
//  PodCast
//
//  Created by Ashish Bogati on 16/12/2022.
//

import UIKit
import SnapKit
import AVFoundation
import Combine

class AudioSliderView: UIView {
    
    // MARK: - Properties
    let playerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    let playerSliderContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var playerSlider: UISlider = {
        let slider = UISlider()
        slider.tintColor = .purple
        slider.backgroundColor = .clear
        return slider
    }()
    
    let bufferProgress: UIProgressView = {
        let view = UIProgressView()
        view.backgroundColor = .clear
        view.progress = 0.0
        view.progressTintColor = UIColor.secondaryLabel.withAlphaComponent(0.5)
        view.trackTintColor = UIColor.clear
        return view
    }()
    
    let timeStampStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fill
        view.axis = .horizontal
        return view
    }()
    
    let currentPlayingTimeLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12)
        label.text = "00:00"
        return label
    }()
    
    let totalPlayingTimeLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .secondaryLabel
        label.textAlignment = .right
        label.text = "00:00"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private var subscriptions = Set<AnyCancellable>()
    
    var viewModel: AudioSliderViewModel
    
    // MARK: - Methods
    init(frame: CGRect = .zero, viewModel: AudioSliderViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupViews()
        observerTimeStamp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        
        playerSlider.addTarget(self, action: #selector(handleCurrentTimeSliderChange), for: .valueChanged)
    
        addSubview(playerStackView)
        playerSliderContainerView.addSubview(bufferProgress)
        bufferProgress.addSubview(playerSlider)
        
        bufferProgress.snp.makeConstraints { make in
            make.centerY.equalTo(playerSliderContainerView.snp.centerY)
            make.leading.equalTo(playerSliderContainerView.snp.leading)
            make.trailing.equalTo(playerSliderContainerView.snp.trailing)
            make.height.equalTo(5)
        }
        
        playerSlider.snp.makeConstraints { make in
            make.centerY.equalTo(bufferProgress.snp.centerY)
            make.leading.equalTo(bufferProgress.snp.leading)
            make.trailing.equalTo(bufferProgress.snp.trailing)
            make.height.equalTo(5)
        }
        
        playerStackView.addArrangedSubview(playerSliderContainerView)
        playerStackView.addArrangedSubview(timeStampStackView)
        
        timeStampStackView.addArrangedSubview(currentPlayingTimeLabel)
        timeStampStackView.addArrangedSubview(totalPlayingTimeLabel)
        
        playerStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self)
        }
        
        playerSliderContainerView.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        
        timeStampStackView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    fileprivate func observerTimeStamp() {
        viewModel.$currentPlayingTime.receive(on: DispatchQueue.main)
            .sink { [weak self] time in
                self?.currentPlayingTimeLabel.text = time
            }.store(in: &subscriptions)
        
        viewModel.$totalTimeValue.receive(on: DispatchQueue.main)
            .sink { [weak self] time in
                self?.totalPlayingTimeLabel.text = time
            }.store(in: &subscriptions)
        
        viewModel.$currentPlayingTimeSlider.receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.playerSlider.value = value
            }.store(in: &subscriptions)
        
        viewModel.$currentBufferValue.receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.bufferProgress.progress = value
            }.store(in: &subscriptions)
    }
    
    // MARK: - Actions
    @objc
    func handleCurrentTimeSliderChange(_ sender: UISlider) {
        viewModel.handleSliderValueChange(sender.value)
    }
}

// MARK: - Protocols
protocol AudioSliderViewFactory {
    func makeAudioSliderFactory(player: AVPlayer) -> AudioSliderView
}
