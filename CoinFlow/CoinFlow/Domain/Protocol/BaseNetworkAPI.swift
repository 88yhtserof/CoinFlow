//
//  BaseNetworkAPI.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/8/25.
//

import Foundation

import Alamofire

protocol BaseNetworkAPI {
    
    var url: URL? { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
    var error: NetworkError.Type { get }
}
