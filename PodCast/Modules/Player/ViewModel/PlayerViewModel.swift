//
//  PlayerViewModel.swift
//  PodCast
//
//  Created by Ashish Bogati on 15/12/2022.
//

import Foundation
import AVFoundation
import Combine

class PlayerViewModel {
    
    // MARK: - Properties
    var player: AVPlayer = AVPlayer()
    @Published var streamURL: String?
    fileprivate var subscriptions = Set<AnyCancellable>()
    
    init() {
        observeStreamURL()
    }
    
    // MARK: - Methods
    func observeStreamURL() {
        $streamURL.receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let url = URL(string: value ?? "") else {
                    return
                }
                let avPlayerItem = AVPlayerItem(url: url)
                self?.player.replaceCurrentItem(with: avPlayerItem)
            }.store(in: &subscriptions)
    }
    
}

// MARK: - Protocol
protocol PlayerViewModelFactory {
    func makePlayerViewModel() -> PlayerViewModel
}
