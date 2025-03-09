//
//  BaseCollectionViewCell.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/9/25.
//

import Foundation

protocol BaseCollectionViewCell {
    
    associatedtype Element
    
    static var identifier: String { get }
    
    func configure(with value: Element)
}
