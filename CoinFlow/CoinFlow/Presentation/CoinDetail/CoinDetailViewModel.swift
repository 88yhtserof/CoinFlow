//
//  CoinDetailViewModel.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/11/25.
//

import Foundation

import RxSwift
import RxCocoa

final class CoinDetailViewModel: BaseViewModel {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let coinsMarket: Driver<CoingeckoCoinsMarket?>
    }
    
    private let id: String
    
    init(id: String) {
        self.id = id
    }
    
    deinit {
        print("CoinDetailViewModel deinit")
    }
    
    func transform(input: Input) -> Output {
        
        let coinsMarket = BehaviorRelay<CoingeckoCoinsMarket?>(value: nil)
        
        Observable.just(id)
            .withUnretained(self)
            .flatMap { owner, id in
                owner.request(id)
            }
            .compactMap{ $0?.first }
            .bind(to: coinsMarket)
            .disposed(by: disposeBag)
        
        return Output(coinsMarket: coinsMarket.asDriver())
    }
}

private extension CoinDetailViewModel {
    
    func request(_ id: String) -> Single<CoingeckoCoinsMarketsResponse?> {
        NetworkManager.shared
            .request(api: CoingeckoNetworkAPI.coinsMarkets(id))
            .debug("coingecko coins markets request")
            .catch { error in
                print("Error", error)
                return Single.just(nil)
            }
    }
}
