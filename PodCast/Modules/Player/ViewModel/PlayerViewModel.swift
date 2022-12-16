//
//  PlayerViewModel.swift
//  PodCast
//
//  Created by Ashish Bogati on 15/12/2022.
//

import Foundation
import AVKit
import AVFoundation
import Combine

class PlayerViewModel {
    
    // MARK: - Properties
    var avPlayer: AVPlayer = AVPlayer()
    @Published var isPlaying: Bool = false
    var pausedRate: Float = 0
    var streamURL: String?
    
    // MARK: - Methods
    @objc
    func play() {
        let url = URL(string: streamURL ?? "")!
        let avPlayerItem = AVPlayerItem(url: url)
        avPlayer.replaceCurrentItem(with: avPlayerItem)
        if avPlayer.timeControlStatus == .paused {
            avPlayer.play()
            isPlaying = true
        } else {
            avPlayer.pause()
            isPlaying = false
        }
        
    }
    
}
