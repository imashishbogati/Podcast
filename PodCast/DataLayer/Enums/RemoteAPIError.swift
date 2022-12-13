//
//  RemoteAPIError.swift
//  PodCast
//
//  Created by Ashish Bogati on 12/12/2022.
//

import Foundation

enum RemoteAPIError: Error {
    case unknown
    case createURL
    case httpError
    case tokenExpire
    case noData
}
