//
//  UpbitNetworkAPI.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/8/25.
//

import Foundation

import Alamofire

enum UpbitNetworkAPI: BaseNetworkAPI {
    case ticker
    
    var url: URL? {
        return URL(string: baseURL + endpoint)
    }
    
    var method: HTTPMethod {
        switch self {
        case .ticker:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .ticker:
            return ["quote_currencies": "KRW"]
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .ticker:
            return nil
        }
    }
    
    var error: any NetworkError.Type {
        return UpbitError.self
    }
}

private extension UpbitNetworkAPI {
    
    var baseURL: String {
        AuthorizationManager.upbit.url ?? ""
    }
    
    var endpoint: String {
        switch self {
        case .ticker:
            return "ticker/all"
        }
    }
}
