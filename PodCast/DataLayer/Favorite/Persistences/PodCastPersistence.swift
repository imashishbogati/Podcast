//
//  UserDefaultPersistence.swift
//  PodCast
//
//  Created by Ashish Bogati on 22/12/2022.
//

import Foundation
import Combine

protocol PodCastPersistence {
    func save(podcast: Podcast, completion: @escaping (Result<Podcast, Error>) -> Void)
    func fetch(completion: @escaping (Result<[Podcast], Error>) -> Void)
    func delete(podcast: Podcast, completion: @escaping (Result<Bool, Error>) -> Void)
}
