//
//  AudioSliderViewModel.swift
//  PodCast
//
//  Created by Ashish Bogati on 18/12/2022.
//

import Foundation
import AVKit
import Combine

class AudioSliderViewModel {
    
    // MARK: - Properties
    
    @Published var currentPlayingTime: String = "00:00"
    @Published var totalTimeValue: String = "00:00"
    @Published var currentPlayingTimeSlider: Float = 0.0
    @Published var currentBufferValue: Float = 0.0
    @Published var currentSliderValue: Float = 0.0
    
    fileprivate var player: AVPlayer
    fileprivate var timeObserverToken: Any?
    
    // MARK: - Methods
    init(avPlayer: AVPlayer) {
        self.player = avPlayer
        observeCurrentPlayingTime()
    }
    
    deinit {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    func handleSliderValueChange(_ value: Float) {
        let percentage = value
        guard let duration = player.currentItem?.duration else {
            return
        }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: Int32(NSEC_PER_SEC))
        
        player.seek(to: seekTime)
        
    }
    
    fileprivate func observeCurrentPlayingTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
                self?.currentPlayingTime = time.toDisplayString()
                self?.totalTimeValue = (self?.player.currentItem?.duration.toDisplayString())!
                self?.updateCurrentTimeSlider()
                self?.updateDownloadProgress()
        }
    }
    
    fileprivate func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(self.player.currentTime())
        let durationsSeconds = CMTimeGetSeconds(self.player.currentItem!.duration)
        let percentage = currentTimeSeconds / durationsSeconds
        currentPlayingTimeSlider = Float(percentage)
    }
    
    fileprivate func updateDownloadProgress() {
        if let range = self.player.currentItem?.loadedTimeRanges.first {
            let time = CMTimeRangeGetEnd(range.timeRangeValue)
            let currentTimeSeconds = CMTimeGetSeconds(time)
            let durationsSeconds = CMTimeGetSeconds(self.player.currentItem!.duration)
            let percentage = currentTimeSeconds / durationsSeconds
            currentBufferValue = Float(percentage)
        }
    }
}
