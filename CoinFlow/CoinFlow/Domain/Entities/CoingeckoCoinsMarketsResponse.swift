//
//  CoingeckoCoinsMarketsResponse.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/11/25.
//

import Foundation

typealias CoingeckoCoinsMarketsResponse = [CoingeckoCoinsMarket]

struct CoingeckoCoinsMarket: Decodable {
    let id: String
    let name: String
    let symbol: String
    let image: String
    let current_price: Double
    let price_change_percentage_24h: Double
    let last_updated: String
    let low_24h: Double
    let high_24h: Double
    let ath: Double
    let ath_date: String
    let atl: Double
    let atl_date: String
    let fully_diluted_valuation: Int
    let total_volume: Int
    let sparkline_in_7d: Sparkline
}

struct Sparkline: Decodable {
    let price: [Double]
}
