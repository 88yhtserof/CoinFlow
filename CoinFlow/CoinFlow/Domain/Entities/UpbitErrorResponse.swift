//
//  UpbitErrorResponse.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/18/25.
//

import Foundation

struct UpbitErrorResponse: Decodable {
    let error: UpbitErrorItem
}

struct UpbitErrorItem: Decodable {
    let message: String
    let name: Int?

    enum CodingKeys: CodingKey {
        case message
        case name
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decode(String.self, forKey: .message)
        self.name = try container.decodeIfPresent(Int.self, forKey: .name)
    }
}

/*
 404 URL 오류
 {
     "error": {
         "message": "no Route matched with those values",
         "name": "not_found" // 타입 다름
     }
 }
 
 {
     "error": {
         "name": 400,
         "message": "Invalid parameter. Check the given value!"
     }
 }
 */
