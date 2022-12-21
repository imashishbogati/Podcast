//
//  PlayerControl.swift
//  PodCast
//
//  Created by Ashish Bogati on 16/12/2022.
//

import UIKit
import SnapKit
import Combine
import AVFoundation

class PlayerControlView: UIView {
    
    // MARK: - Properties
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
        button.tintColor = .label
        return button
    }()
    
    let forwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "fastforward15"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private var subscriptions = Set<AnyCancellable>()
    var viewModel: PlayerControlViewModel
    weak var delegate: PlayerControlViewDelegate?
    
    // MARK: - Methods
    init(frame: CGRect = .zero, viewModel: PlayerControlViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupViews()
        observeViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        playButton.addTarget(viewModel, action: #selector(viewModel.play), for: .touchUpInside)
        rewindButton.addTarget(viewModel, action: #selector(viewModel.rewind), for: .touchUpInside)
        forwardButton.addTarget(viewModel, action: #selector(viewModel.fastForward), for: .touchUpInside)
        addSubview(playerControllerStackView)
        
        playerControllerStackView.addArrangedSubview(rewindButton)
        playerControllerStackView.addArrangedSubview(playButton)
        playerControllerStackView.addArrangedSubview(forwardButton)
        
        playerControllerStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self)
        }
    }
    
    fileprivate func observeViewModel() {
        viewModel.$isPlaying.receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                let image = status == true ? UIImage(named: "pause") : UIImage(named: "play")
                self?.delegate?.isAudioPlaying(status: status)
                self?.playButton.setImage(image, for: .normal)
            }.store(in: &subscriptions)
    }
}

// MARK: - Protocols
protocol PlayerControlViewDelegate: AnyObject {
    func isAudioPlaying(status: Bool)
}

protocol PlayerControlViewFactory {
    func makePlayerControl(player: AVPlayer) -> PlayerControlView
}
