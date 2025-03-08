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
        let changeSort: ControlEvent<ExchangeBar.Sort>
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
        
        let marketList = BehaviorRelay(value: marketList.sorted(by: { $0.accTradePrice > $1.accTradePrice }))
        
        input.changeSort
            .withLatestFrom(marketList){ ($0, $1) }
            .map { sort, list in
                switch sort {
                case .tradePrice(let order):
                    switch order {
                    case .none:
                        break
                    case .desc:
                        return list.sorted(by: { $0.tradePrice > $1.tradePrice })
                    case .asc:
                        return list.sorted(by: { $0.tradePrice < $1.tradePrice })
                    }
                case .changePrice(let order):
                    switch order {
                    case .none:
                        break
                    case .desc:
                        return list.sorted(by: { $0.signedChangeRate > $1.signedChangeRate })
                    case .asc:
                        return list.sorted(by: { $0.signedChangeRate < $1.signedChangeRate })
                    }
                case .accTradePrice(let order):
                    switch order {
                    case .none:
                        break
                    case .desc:
                        return list.sorted(by: { $0.accTradePrice > $1.accTradePrice })
                    case .asc:
                        return list.sorted(by: { $0.accTradePrice < $1.accTradePrice })
                    }
                }
                return list.sorted(by: { $0.accTradePrice > $1.accTradePrice })
            }
            .bind(to: marketList)
            .disposed(by: disposeBag)
        
        return Output(marketList: marketList.asDriver())
    }
    
}
