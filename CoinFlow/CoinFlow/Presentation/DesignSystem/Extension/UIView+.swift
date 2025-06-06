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
    
    func cornerRadius(_ radius: CGFloat = 10.0) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func border(width: CGFloat = 1.0, color: UIColor = CoinFlowColor.title) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}
