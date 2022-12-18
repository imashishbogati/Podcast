//
//  PlayerControl.swift
//  PodCast
//
//  Created by Ashish Bogati on 16/12/2022.
//

import UIKit
import SnapKit

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
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        addSubview(playerControllerStackView)
        
        playerControllerStackView.addArrangedSubview(rewindButton)
        playerControllerStackView.addArrangedSubview(playButton)
        playerControllerStackView.addArrangedSubview(forwardButton)
        
        playerControllerStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self)
        }
    }
}
