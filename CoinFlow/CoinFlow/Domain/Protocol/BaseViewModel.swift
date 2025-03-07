//
//  BaseViewModel.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/7/25.
//

import Foundation

import RxSwift

protocol BaseViewModel {
    
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get }
    
    func transform(input: Input) -> Output
}
