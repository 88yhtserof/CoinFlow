//
//  CoinDateFomatter.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/9/25.
//

import Foundation

enum CoinDateFomatter {
    case trending(Date)
    case detailUpdating(Date)
    case detailInfo(Date)
    case responseDate(String)
    
    var string: String {
        switch self {
        case .trending(let date):
            return CoinDateFomatter.trendingFormat.string(from: date)
        case .detailUpdating(let date):
            return CoinDateFomatter.detailUpdatingFormat.string(from: date)
        case .detailInfo(let date):
            return CoinDateFomatter.detailInfoFormat.string(from: date) // 데이터 확인
        case .responseDate:
            return ""
        }
    }
    
    var date: Date? {
        switch self {
        case .responseDate(let string):
            return CoinDateFomatter.responseFormat.date(from: string)
        default:
            return nil
        }
    }
    
    static let trendingFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd HH:mm 기준"
        return formatter
    }()
    
    static let detailUpdatingFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd HH:mm:ss 업데이트"
        return formatter
    }()
    
    static let detailInfoFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 M월 d일"
        return formatter
    }()
    
    static let responseFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
}
