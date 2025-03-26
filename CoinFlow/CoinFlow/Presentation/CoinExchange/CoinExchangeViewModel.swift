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
        let errorMessage: Driver<(NetworkError.ErrorDescription, (() -> Void)?)>
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
        let errorMessage = PublishRelay<(NetworkError.ErrorDescription, (() -> Void)?)>()
        
        let timer = Observable<Int>
            .timer(.seconds(5), period: .seconds(5), scheduler: MainScheduler.asyncInstance)
        
        let retryRequest = PublishRelay<Void>()
        
        let validateNetworkConnection = NetworkMonitorManager.shared.isConnected.filter{ $0 }
        let unvalidateNetworkConnection = NetworkMonitorManager.shared.isConnected.filter{ !$0 }
        
        unvalidateNetworkConnection
            .map { _ in
                let handler = { retryRequest.accept(()) }
                let message = "네트워크 연결이 일시적으로 원활하지 않습니다.\n데이터 또는 Wi-Fi 연결 상태를 확인해주세요."
                return (message, handler)
            }
            .bind(to: errorMessage)
            .disposed(by: disposeBag)
        
        Observable<Void>
            .merge(input.loadView.asObservable(),
                   timer.map{_ in Void() },
                   retryRequest.asObservable())
            .withLatestFrom(validateNetworkConnection)
            .flatMap { _ in
                NetworkManager.shared.request(api: UpbitNetworkAPI.ticker)
                    .catch { error in
                        let handler = { retryRequest.accept(Void()) }
                        errorMessage.accept((error.localizedDescription, handler ))
                        return Single.just([])
                    }
            }
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
                      errorMessage: errorMessage.asDriver(onErrorJustReturn: ("", nil)))
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
