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
    
    var url: URL? {
        return URL(string: baseURL + endpoint)
    }
    
    var method: HTTPMethod {
        switch self {
        case .trending:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .trending:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .trending:
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
        }
    }
}
