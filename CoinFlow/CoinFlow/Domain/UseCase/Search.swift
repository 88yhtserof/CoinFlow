//
//  Search.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/10/25.
//

import Foundation

import RxSwift
import RxCocoa

enum Search {
    
    static func search(keyword: String) -> Observable<String> {
        return Observable.just(keyword)
            .map{ $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter{ !$0.isEmpty }
    }
}
