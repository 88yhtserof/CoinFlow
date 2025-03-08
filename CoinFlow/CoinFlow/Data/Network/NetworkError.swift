//
//  NetworkError.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/8/25.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case failedDecoding
    case failedRequest
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .failedDecoding:
            return "Failed to decode data"
        case .failedRequest:
            return "Failed to make request"
        case .unknown:
            return "Unknown error"
        }
    }
}
