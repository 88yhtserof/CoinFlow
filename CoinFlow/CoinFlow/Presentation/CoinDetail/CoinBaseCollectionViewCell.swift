//
//  CoinBaseCollectionViewCell.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/11/25.
//

import UIKit

class CoinBaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = UIView()
        view.backgroundColor = CoinFlowColor.subBackground
        view.cornerRadius()
        backgroundView = view
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
