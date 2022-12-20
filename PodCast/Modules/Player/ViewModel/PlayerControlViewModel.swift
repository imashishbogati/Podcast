//
//  PlayerControlViewModel.swift
//  PodCast
//
//  Created by Ashish Bogati on 18/12/2022.
//

import Foundation
import AVKit
import Combine

class PlayerControlViewModel {
    
    // MARK: - Properties
    @Published var isPlaying: Bool = false
    fileprivate var player: AVPlayer
    
    // MARK: - Methods
    init(player: AVPlayer) {
        self.player = player
    }
    
    @objc
    func play() {
        isPlaying = true
        if player.timeControlStatus == .paused {
            player.play()
            isPlaying = true
        } else {
            player.pause()
            isPlaying = false
        }
    }
    
    @objc
    func rewind() {
        let seconds = CMTimeMake(value: 15, timescale: 1)
        let seekTime = CMTimeSubtract(player.currentTime(), seconds)
        player.seek(to: seekTime)
    }
    
    @objc
    func fastForward() {
        let seconds = CMTimeMake(value: 15, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), seconds)
        player.seek(to: seekTime)
    }
}

// MARK: - Protocol
protocol PlayerControlViewModelFactory {
    func makePlayerControlViewModel() -> PlayerControlViewModel
}
