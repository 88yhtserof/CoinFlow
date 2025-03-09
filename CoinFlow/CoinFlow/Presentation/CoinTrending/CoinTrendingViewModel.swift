//
//  CoinTrendingViewModel.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/9/25.
//

import Foundation

import RxSwift
import RxCocoa

final class CoinTrendingViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let loadView: ControlEvent<Void>
    }
    
    struct Output {
        let trendingList: Driver<([CoinTrendingViewController.Item], [CoinTrendingViewController.Item])>
    }
    
    init() {
        print("CoinTrendingViewModel init")
    }
    
    deinit {
        print("CoinTrendingViewModel deinit")
    }
    
    func transform(input: Input) -> Output {
        
        let trendingList = BehaviorRelay<([CoinTrendingViewController.Item], [CoinTrendingViewController.Item])>(value: ([], []))
        
        let response = input.loadView
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.requestTrending()
            }
            .compactMap{ $0 }
            .debug("loadView")
            .share()
        
        let searchKeywordList = response
            .map{ $0.coins }
            .map{ $0[0..<14] }
            .map{ $0.map{ CoinTrendingViewController.Item.searchKeyword($0) } }
        
        let nftList = response
            .map{ $0.nfts }
            .map{ $0[0..<7] }
            .map{ $0.map{ CoinTrendingViewController.Item.nft($0) } }
        
        Observable.zip(searchKeywordList, nftList)
            .bind(to: trendingList)
            .disposed(by: disposeBag)
        
        return Output(trendingList: trendingList.asDriver())
    }
}

private extension CoinTrendingViewModel {
    
    func requestTrending() -> Single<CoingeckoTrendingResponse?> {
        NetworkManager.shared.request(api: CoingeckoNetworkAPI.trending)
            .debug("cingecko trending request")
            .catch { error in
                print("Error", error)
                return Single.just(nil)
            }
    }
}
