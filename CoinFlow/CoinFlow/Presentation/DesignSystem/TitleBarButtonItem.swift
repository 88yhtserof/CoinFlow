//
//  TitleBarButtonItem.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/7/25.
//

import UIKit

final class TitleBarButtonItem: UIBarButtonItem {
    
    private let titleLabel = UILabel()
    
    init(title: String) {
        super.init()
        titleLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        titleLabel.text = title
        titleLabel.textColor = CoinFlowColor.title
        
        self.customView = titleLabel
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
