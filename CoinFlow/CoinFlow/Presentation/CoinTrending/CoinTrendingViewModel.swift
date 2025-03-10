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
        let searchText: ControlProperty<String>
        let tapSearchButton: ControlEvent<Void>
    }
    
    struct Output {
        let trendingList: Driver<([CoinTrendingViewController.Item], [CoinTrendingViewController.Item])>
        let searchedText: Driver<String?>
    }
    
    init() {
        print("CoinTrendingViewModel init")
    }
    
    deinit {
        print("CoinTrendingViewModel deinit")
    }
    
    func transform(input: Input) -> Output {
        
        let trendingList = BehaviorRelay<([CoinTrendingViewController.Item], [CoinTrendingViewController.Item])>(value: ([], []))
        let searchedText = PublishRelay<String?>()
        
        let timer = Observable<Int>
            .timer(.seconds(10 * 60), period: .seconds(10 * 60), scheduler: MainScheduler.instance)
        
        let response = Observable<Void>
            .merge(input.loadView.asObservable(), timer.map{ _ in Void() })
            .withUnretained(self)
            .flatMapLatest { owner, _ in
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

        input.tapSearchButton
            .withLatestFrom(input.searchText)
            .flatMap{ text in
                Search.search(keyword: text)
            }
            .bind(to: searchedText)
            .disposed(by: disposeBag)
        
        return Output(trendingList: trendingList.asDriver(),
                      searchedText: searchedText.asDriver(onErrorJustReturn: nil))
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
