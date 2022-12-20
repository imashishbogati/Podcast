//
//  SoundControlViewModel.swift
//  PodCast
//
//  Created by Ashish Bogati on 18/12/2022.
//

import Foundation
import AVKit
import Combine

class SoundControlViewModel {
    
    // MARK: - Properties
    fileprivate var player: AVPlayer
    @Published var volume: Float = 1
    fileprivate var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Methods
    init(player: AVPlayer) {
        self.player = player
        observeVolumeChanged()
    }
    
    func observeVolumeChanged() {
        $volume.receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.player.volume = value
            }.store(in: &subscriptions)
    }
    
}

// MARK: - Protocol
protocol SoundControlViewModelFactory {
    func makeSoundControlViewModel() -> SoundControlViewModel
}
