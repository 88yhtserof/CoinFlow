//
//  CoinExchangeViewController.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/6/25.
//

import UIKit

final class CoinExchangeViewController: UIViewController {
    
    private let exchangeBar = ExchangeBar()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
}

//MARK: - Configuration
private extension CoinExchangeViewController {
    
    func configureView() {
        view.backgroundColor = CoinFlowColor.background
        
        navigationItem.leftBarButtonItem = TitleBarButtonItem(title: "거래소")
    }
    
    func configureHierarchy() {
        view.addSubviews([exchangeBar/*, collectionView*/])
    }
    
    func configureConstraints() {
        
        exchangeBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
