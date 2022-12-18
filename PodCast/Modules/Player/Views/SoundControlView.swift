//
//  SoundControl.swift
//  PodCast
//
//  Created by Ashish Bogati on 16/12/2022.
//

import UIKit
import SnapKit

class SoundControlView: UIView {
    
    // MARK: - Properties
    let volumeControlStackView: UIStackView = {
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
        slider.value = 1
        return slider
    }()
    
    fileprivate var viewModel: SoundControlViewModel
    
    
    // MARK: - Methods
    init(frame: CGRect = .zero, viewModel: SoundControlViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupViews
    fileprivate func setupViews() {
        volumeSlider.addTarget(self, action: #selector(handleVolumeValueChanged), for: .valueChanged)
        addSubview(volumeControlStackView)
        
        volumeControlStackView.addArrangedSubview(muteButton)
        volumeControlStackView.addArrangedSubview(volumeSlider)
        volumeControlStackView.addArrangedSubview(maxVolumeButton)
        
        volumeControlStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self)
        }
    }
    
    // MARK: - Actions
    @objc
    func handleVolumeValueChanged(_ sender: UISlider) {
        viewModel.volume = sender.value
    }
}
