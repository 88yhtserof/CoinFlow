//
//  CoinExchangeViewModel.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/7/25.
//

import UIKit

import RxSwift
import RxCocoa

final class CoinExchangeViewModel: BaseViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        let marketList: Driver<[MarketData]>
    }
    
    var disposeBag = DisposeBag()
    
    private var marketList: [MarketData]
    
    init() {
        self.marketList = mockMarketData
    }
    
    func transform(input: Input) -> Output {
        
        let marketList = BehaviorRelay(value: marketList)
        
        return Output(marketList: marketList.asDriver())
    }
    
}
