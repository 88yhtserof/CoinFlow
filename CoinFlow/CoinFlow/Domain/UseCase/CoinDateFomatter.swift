//
//  CoinDateFomatter.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/9/25.
//

import Foundation

enum CoinDateFomatter {
    case trending(Date)
    
    var string: String {
        switch self {
        case .trending(let date):
            return CoinDateFomatter.trendingFormat.string(from: date)
        }
    }
    
    static let trendingFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd HH:mm 기준"
        return formatter
    }()
}
