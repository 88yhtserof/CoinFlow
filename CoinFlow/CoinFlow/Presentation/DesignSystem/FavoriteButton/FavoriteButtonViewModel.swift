//
//  FavoriteButtonViewModel.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/11/25.
//

import Foundation

import RxSwift
import RxCocoa

final class FavoriteButtonViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    private let repository = FavoriteRepository.shared
    
    struct Input {
        let isSelectedState: ControlProperty<Bool>
        let selectButton: ControlEvent<Void>
    }
    
    struct Output {
        let selectedState: Driver<Bool>
    }
    
    private let id: String
    
    init(id: String) {
        print("FavoriteButtonViewModel init")
        self.id = id
    }
    
    deinit {
        print("FavoriteButtonViewModel deinit")
    }
    
    func transform(input: Input) -> Output {
        
        let selectedState = BehaviorRelay(value: false)
        
        input.selectButton
            .withLatestFrom(input.isSelectedState)
            .withUnretained(self)
            .map { owner, isFavorite in
                if isFavorite {
                    owner.repository.add(FavoriteTable(id: owner.id))
                    return "Add favorite"
                } else {
                    owner.repository.delete(FavoriteTable(id: owner.id))
                    return "Delete favorite"
                }
            }.subscribe { text in
                print("Present Toast", text)
            }
            .disposed(by: disposeBag)
        
        Observable<String>.just(id)
            .map{ FavoriteTable(id: $0) }
            .withUnretained(self)
            .map{ owner, object in
                owner.repository.isContained(object)
            }
            .bind(to: selectedState)
            .disposed(by: disposeBag)
        
        return Output(selectedState: selectedState.asDriver())
    }
}
