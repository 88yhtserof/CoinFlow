//
//  CoingeckoErrorResponse.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/18/25.
//

import Foundation

struct CoingeckoErrorResponse: Decodable {
    let error: CoingeckoErrorItem
}

struct CoingeckoErrorItem: Decodable {
    let error_code: Int
    let error_message: String
}

/*
 {
     "status": {
         "error_code": 429,
         "error_message": "You've exceeded the Rate Limit. Please visit https://www.coingecko.com/en/api/pricing to subscribe to our API plans for higher rate limits."
     }
 }
 */
