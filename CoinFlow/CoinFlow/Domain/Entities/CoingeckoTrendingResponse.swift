//
//  CoingeckoTrendingResponse.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/9/25.
//

import Foundation

struct CoingeckoTrendingResponse: Decodable {
    let coins: [CoingeckoTrendingCoin]
    let nfts: [CoingeckoTrendingNft]
}


struct CoingeckoTrendingCoin: Decodable, Hashable {
    let item: CoingeckoTrendingCoinItem
}

struct CoingeckoTrendingCoinItem: Decodable, Hashable {
    let id: String
    let coin_id: Int
    let name: String
    let symbol: String
    let thumb: String
    let small: String
    let large: String
    let data: CoingeckoTrendingCoinData
}

struct CoingeckoTrendingCoinData: Decodable, Hashable {
    let price: Double
    let price_change_percentage_24h: PriceChangePercentage24h
}

struct PriceChangePercentage24h: Decodable, Hashable {
    let krw: Double
}

struct CoingeckoTrendingNft: Decodable, Hashable {
    let name: String
    let thumb: String
    let data: CoingeckoTrendingNftData
}

struct CoingeckoTrendingNftData: Decodable, Hashable {
    let floor_price: String
    let floor_price_in_usd_24h_percentage_change: String
}
