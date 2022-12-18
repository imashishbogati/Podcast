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
    @Published var isPlaying: Bool = false
    
    fileprivate var avPlayer: AVPlayer
    
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
        if isPlaying {
            let seconds = CMTimeMake(value: 15, timescale: 1)
            let seekTime = CMTimeSubtract(avPlayer.currentTime(), seconds)
            avPlayer.seek(to: seekTime)
        }
        
    }
    
    @objc
    func fastForward() {
        if isPlaying {
            let seconds = CMTimeMake(value: 15, timescale: 1)
            let seekTime = CMTimeAdd(avPlayer.currentTime(), seconds)
            avPlayer.seek(to: seekTime)
        }
    }
}
