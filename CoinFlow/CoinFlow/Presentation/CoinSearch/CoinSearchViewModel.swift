//
//  CoinSearchViewModel.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/10/25.
//

import Foundation

import RxSwift
import RxCocoa

final class CoinSearchViewModel: BaseViewModel {
    
    struct Input {
    }
    
    struct Output {
        let titleList: Driver<[CoinSearchViewController.Item]>
        let indicatorList: Driver<[CoinSearchViewController.Item]>
        
        let contentList: Driver<[CoinSearchViewController.Item]>
        let searchResultList: Driver<CoinSearchViewController.Item?>
        let itemTuple: Driver<([CoinSearchViewController.Item], [CoinSearchViewController.Item], [CoinSearchViewController.Item])>
    }
    
    var disposeBag = DisposeBag()
    
    private let searchKeyword: String
    private let titleList: [CoinSearchViewController.Item]
    private let indicatorList: [CoinSearchViewController.Item]
    
    init(searchKeyword: String) {
        print("CoinSearchViewModel init")
        
        self.searchKeyword = searchKeyword
        self.titleList = [.title("코인"), .title("NFT"), .title("거래소")]
        self.indicatorList = [.indicator(1), .indicator(2), .indicator(3)]
    }
    
    deinit {
        print("CoinSearchViewModel deinit")
    }
    
    func transform(input: Input) -> Output {
        
        let titleList = BehaviorRelay(value: titleList)
        let indicatorList = BehaviorRelay(value: indicatorList)
        let contentList = PublishRelay<[CoinSearchViewController.Item]>()
        let searchResultList = BehaviorRelay<CoinSearchViewController.Item?>(value: nil)
        
        let itemTuple = BehaviorRelay<([CoinSearchViewController.Item], [CoinSearchViewController.Item], [CoinSearchViewController.Item])>(value: ([], [], []))
        
        Observable.just(searchKeyword)
            .flatMap {
                NetworkManager.shared
                    .request(api: CoingeckoNetworkAPI.search($0))
                    .debug("cingecko search request")
                    .catch { error in
                        return Single.just(nil)
                    }
            }
            .compactMap{ $0 }
            .map { (response: CoingeckoSearchResponse) in
                CoinSearchViewController.Item.content(.coins(response.coins))
            }
            .bind(to: searchResultList)
            .disposed(by: disposeBag)
        
        searchResultList
            .compactMap{ $0 }
            .map { contentCoins in
                [contentCoins, .content(.nfts([])), .content(.exchanges([])) ]
            }
            .bind(to: contentList)
            .disposed(by: disposeBag)
        
        Observable
            .zip(titleList, indicatorList, contentList)
            .bind(to: itemTuple)
            .disposed(by: disposeBag)
        
        
        return Output(titleList: titleList.asDriver(),
                      indicatorList: indicatorList.asDriver(),
                      contentList: contentList.asDriver(onErrorJustReturn: []),
                      searchResultList: searchResultList.asDriver(),
                      itemTuple: itemTuple.asDriver())
    }
    
}
