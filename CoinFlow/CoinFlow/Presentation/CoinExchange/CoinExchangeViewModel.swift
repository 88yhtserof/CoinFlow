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
        let loadView: ControlEvent<Void>
    }
    
    struct Output {
        let sortedMarketList: Driver<[MarketTickerResponse]>
        let errorMessage: Driver<String>
    }
    
    var disposeBag = DisposeBag()
    
    init() {
        print("CoinExchangeViewModel init")
    }
    
    deinit {
        print("CoinExchangeViewModel deinit")
    }
    
    func transform(input: Input) -> Output {
        
        let selectedSort = BehaviorRelay<ExchangeBar.Sort>(value: .accTradePrice(.desc))
        let marketList = BehaviorRelay<[MarketTickerResponse]>(value: [])
        let sortedMarketList = BehaviorRelay<[MarketTickerResponse]>(value: [])
        let errorMessage = PublishRelay<String>()
        
        let timer = Observable<Int>
            .timer(.seconds(5), period: .seconds(5), scheduler: MainScheduler.asyncInstance)
        
        Observable<Void>
            .merge(input.loadView.asObservable(), timer.map{_ in Void() })
            .flatMap { _ in
                NetworkManager.shared.request(api: UpbitNetworkAPI.ticker)
                    .catch { error in
                        errorMessage.accept(error.localizedDescription)
                        return Single.just([])
                    }
            }
            .debug("load view")
            .bind(to: marketList)
            .disposed(by: disposeBag)
        
        marketList
            .withLatestFrom(selectedSort){ ($1, $0) }
            .withUnretained(self){ ($0, $1.0, $1.1) }
            .map { value in
                let (owner, sort, list) = value
                return owner.sortedTickers(by: sort, with: list)
            }
            .bind(to: sortedMarketList)
            .disposed(by: disposeBag)
        
        
        input.changeSort
            .withLatestFrom(sortedMarketList){ ($0, $1) }
            .withUnretained(self){ ($0, $1.0, $1.1) }
            .map { value in
                let (owner, sort, list) = value
                selectedSort.accept(sort)
                return owner.sortedTickers(by: sort, with: list)
            }
            .bind(to: sortedMarketList)
            .disposed(by: disposeBag)
        
        return Output(sortedMarketList: sortedMarketList.asDriver(),
                      errorMessage: errorMessage.asDriver(onErrorJustReturn: ""))
    }
    
    func sortedTickers(by sort: ExchangeBar.Sort, with list: [MarketTickerResponse]) -> [MarketTickerResponse] {
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
}
