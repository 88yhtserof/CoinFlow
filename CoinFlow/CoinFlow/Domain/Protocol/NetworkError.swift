//
//  NetworkError.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/14/25.
//

import Foundation

protocol NetworkError where Self: LocalizedError {
    
    typealias ErrorDescription = String
    
    var statusCode: Int? { get }
}
