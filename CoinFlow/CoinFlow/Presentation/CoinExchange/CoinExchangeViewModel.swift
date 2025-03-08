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
        let loadView: ControlEvent<Bool>
    }
    
    struct Output {
        let marketList: Driver<[MarketTickerResponse]>
    }
    
    var disposeBag = DisposeBag()
    
    private var marketList: [MarketTickerResponse] = []
    
    init() {
        print("CoinExchangeViewModel init")
    }
    
    deinit {
        print("CoinExchangeViewModel deinit")
    }
    
    func transform(input: Input) -> Output {
        
        let marketList = BehaviorRelay(value: marketList.sorted(by: { $0.acc_trade_price > $1.acc_trade_price }))
        
        input.loadView
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.requestMarketTicker()
            }
            .debug("load view")
            .bind(to: marketList)
            .disposed(by: disposeBag)
        
        Observable<Int>
            .timer(.seconds(5), period: .seconds(5), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .flatMap{ owner, _ in
                owner.requestMarketTicker()
            }
            .debug("timer")
            .bind(to: marketList)
            .disposed(by: disposeBag)
        
        
        input.changeSort
            .withLatestFrom(marketList){ ($0, $1) }
            .map { sort, list in
                switch sort {
                case .tradePrice(let order):
                    switch order {
                    case .none:
                        break
                    case .desc:
                        return list.sorted(by: { $0.trade_price > $1.trade_price })
                    case .asc:
                        return list.sorted(by: { $0.trade_price < $1.trade_price })
                    }
                case .changePrice(let order):
                    switch order {
                    case .none:
                        break
                    case .desc:
                        return list.sorted(by: { $0.signed_change_rate > $1.signed_change_rate })
                    case .asc:
                        return list.sorted(by: { $0.signed_change_rate < $1.signed_change_rate })
                    }
                case .accTradePrice(let order):
                    switch order {
                    case .none:
                        break
                    case .desc:
                        return list.sorted(by: { $0.acc_trade_price > $1.acc_trade_price })
                    case .asc:
                        return list.sorted(by: { $0.acc_trade_price < $1.acc_trade_price })
                    }
                }
                return list.sorted(by: { $0.acc_trade_price > $1.acc_trade_price })
            }
            .bind(to: marketList)
            .disposed(by: disposeBag)
        
        return Output(marketList: marketList.asDriver())
    }
    
    func requestMarketTicker() -> Single<[MarketTickerResponse]> {
        NetworkManager.shared.request(api: UpbitNetworkAPI.ticker)
            .debug("upbit ticker request")
            .catch { error in
                print("Error", error)
                return Single.just([])
            }
    }
}
