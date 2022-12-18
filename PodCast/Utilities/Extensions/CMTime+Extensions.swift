//
//  CMTime+Extensions.swift
//  PodCast
//
//  Created by Ashish Bogati on 16/12/2022.
//

import AVKit

extension CMTime {
    func toDisplayString() -> String {
        let totalSeconds = Int(CMTimeGetSeconds(self))
        
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        
        let currentTimeFormatString = String(format: "%02d:%02d", minutes, seconds)
        return currentTimeFormatString
    }
}
