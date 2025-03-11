//
//  CoingeckoSearchResponse.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/10/25.
//

import Foundation

struct CoingeckoSearchResponse: Decodable, Hashable {
    let coins: [CoingeckoSearchCoin]
}

struct CoingeckoSearchCoin: Decodable, Hashable {
    let id: String
    let name: String
    let symbol: String
    let market_cap_rank: Int?
    let thumb: String
    let large: String
}
