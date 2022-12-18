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
    fileprivate var avPlayer: AVPlayer
    
    // MARK: - Methods
    init(avPlayer: AVPlayer) {
        self.avPlayer = avPlayer
    }
    
    @objc
    func play() {
        isPlaying = true
        if avPlayer.timeControlStatus == .paused {
            avPlayer.play()
            isPlaying = true
        } else {
            avPlayer.pause()
            isPlaying = false
        }
    }
    
    @objc
    func rewind() {
        let seconds = CMTimeMake(value: 15, timescale: 1)
        let seekTime = CMTimeSubtract(avPlayer.currentTime(), seconds)
        avPlayer.seek(to: seekTime)
    }
    
    @objc
    func fastForward() {
        let seconds = CMTimeMake(value: 15, timescale: 1)
        let seekTime = CMTimeAdd(avPlayer.currentTime(), seconds)
        avPlayer.seek(to: seekTime)
    }
}
