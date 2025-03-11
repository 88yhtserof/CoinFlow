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
        
    }
    
    private let id: String
    
    init(id: String) {
        self.id = id
    }
    
    deinit {
        print("CoinDetailViewModel deinit")
    }
    
    func transform(input: Input) -> Output {
        
        
        return Output()
    }
}
