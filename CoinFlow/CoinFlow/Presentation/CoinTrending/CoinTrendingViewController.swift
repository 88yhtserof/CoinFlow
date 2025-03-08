//
//  CoinTrendingViewController.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/6/25.
//

import UIKit

final class CoinTrendingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
}

//MARK: - Configuration
private extension CoinTrendingViewController {
    
    func configureView() {
        view.backgroundColor = CoinFlowColor.background
        navigationItem.leftBarButtonItem = TitleBarButtonItem(title: "가상자산 / 심볼 검색")
    }
    
    func configureHierarchy() {
        
    }
    
    func configureConstraints() {
        
    }
}
