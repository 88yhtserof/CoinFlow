//
//  MarketTickerResponse.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/8/25.
//

import Foundation

struct MarketTickerResponse: Decodable {
    let market: String
    let trade_price: Double
    let signed_change_price: Double
    let signed_change_rate: Double
    let acc_trade_price: Double
}
