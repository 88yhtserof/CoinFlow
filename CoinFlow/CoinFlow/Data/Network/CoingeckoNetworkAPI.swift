//
//  CoingeckoNetworkAPI.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/9/25.
//

import Foundation

import Alamofire

enum CoingeckoNetworkAPI: BaseNetworkAPI {
    case trending
    case search(String)
    case coinsMarkets(String)
    
    var url: URL? {
        return URL(string: baseURL + endpoint)
    }
    
    var method: HTTPMethod {
        switch self {
        case .trending, .search, .coinsMarkets:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .trending:
            return nil
        case .search(let text):
            return ["query": text]
        case .coinsMarkets(let text):
            return ["vs_currency": "krw", "ids": text, "sparkline": "true"]
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .trending, .search, .coinsMarkets:
            return nil
        }
    }
}

private extension CoingeckoNetworkAPI {
    
    var baseURL: String {
        AuthorizationManager.coingecko.url ?? ""
    }
    
    var endpoint: String {
        switch self {
        case .trending:
            return "search/trending"
        case .search:
            return "search"
        case .coinsMarkets:
            return "coins/markets"
        }
    }
}
