//
//  CoinNumberFormatter.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/7/25.
//

import Foundation

enum CoinNumberFormatter {
    case tradePrice(number: Double)
    case changeRate(number: Double)
    case changePrice(number: Double)
    case accTradePrice(number: Double)
    case currentPrice(number: Int)
    
    var string: String? {
        switch self {
        case .tradePrice(let number):
            return CoinNumberFormatter.decimal(by: .tradePrice(number as NSNumber))
        case .changeRate(let number):
            return CoinNumberFormatter.percent(number, point: 2)
        case .changePrice(let number):
            return CoinNumberFormatter.decimal(by: .changePrice(number as NSNumber))
        case .accTradePrice(let number):
            return CoinNumberFormatter.truncToMilions(number)
        case .currentPrice(let number):
            return CoinNumberFormatter.decimal(by: .standard(number as NSNumber))
        }
    }
}

//MARK: - Format
private extension CoinNumberFormatter {
    enum FormatterType {
        case standard(NSNumber)
        case tradePrice(NSNumber)
        case changePrice(NSNumber)
    }
    
    static let standardDecimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    static let tradePriceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 1
        return formatter
    }()
    
    static let changePriceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
}

//MARK: - Configuration
private extension CoinNumberFormatter {
    
    static func truncToMilions(_ number: Double) -> String {
        if number > 1000000 {
            let value = Int(number) / 1000000
            return String(format: "%@백만", value.formatted())
        } else {
            return number.formatted()
        }
    }
    
    static func percent(_ number: Double, point: Int) -> String {
        return String(format: "%.\(point)f%%", number)
    }
    
    static func decimal(by formatter: FormatterType) -> String? {
        switch formatter {
        case .standard(let number):
            return CoinNumberFormatter.standardDecimalFormatter.string(from: number)
        case .tradePrice(let number):
            return CoinNumberFormatter.tradePriceFormatter.string(from: number)
        case .changePrice(let number):
            return CoinNumberFormatter.changePriceFormatter.string(from: number)
        }
    }
}
