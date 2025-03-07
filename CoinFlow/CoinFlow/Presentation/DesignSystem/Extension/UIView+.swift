//
//  UIView+.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/6/25.
//

import UIKit

extension UIView {
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach{ addSubview($0) }
    }
}
