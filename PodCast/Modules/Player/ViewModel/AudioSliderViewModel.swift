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
    
    @Published var isEnlargeEpisode: Bool = false
    @Published var currentPlayingTime: String = "00:00"
    @Published var totalTimeValue: String = "00:00"
    @Published var currentPlayingTimeSlider: Float = 0.0
    @Published var currentBufferValue: Float = 0.0
    @Published var currentSliderValue: Float = 0.0
    
    fileprivate var avPlayer: AVPlayer
    
    init(avPlayer: AVPlayer) {
        self.avPlayer = avPlayer
        checkForAudioStartPlaying()
        observeCurrentPlayingTime()
    }
    
    func handleSliderValueChange(_ value: Float) {
        let percentage = value
        guard let duration = avPlayer.currentItem?.duration else {
            return
        }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: Int32(NSEC_PER_SEC))
        avPlayer.seek(to: seekTime)
    }
    
    fileprivate func checkForAudioStartPlaying() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        avPlayer.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            self.isEnlargeEpisode = true
        }
    }
    
    fileprivate func observeCurrentPlayingTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        avPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            if self.avPlayer.timeControlStatus == .playing {
                self.currentPlayingTime = time.toDisplayString()
                self.totalTimeValue = (self.avPlayer.currentItem?.duration.toDisplayString())!
                self.updateCurrentTimeSlider()
                self.updateDownloadProgress()
            }
            
        }
    }
    
    fileprivate func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(self.avPlayer.currentTime())
        let durationsSeconds = CMTimeGetSeconds(self.avPlayer.currentItem!.duration)
        let percentage = currentTimeSeconds / durationsSeconds
        currentPlayingTimeSlider = Float(percentage)
    }
    
    fileprivate func updateDownloadProgress() {
        if let range = self.avPlayer.currentItem?.loadedTimeRanges.first {
            let time = CMTimeRangeGetEnd(range.timeRangeValue)
            let currentTimeSeconds = CMTimeGetSeconds(time)
            let durationsSeconds = CMTimeGetSeconds(self.avPlayer.currentItem!.duration)
            let percentage = currentTimeSeconds / durationsSeconds
            currentBufferValue = Float(percentage)
        }
    }
}
