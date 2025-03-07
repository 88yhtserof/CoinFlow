//
//  CoinExchangeViewController.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/6/25.
//

import UIKit

final class CoinExchangeViewController: UIViewController {
    
    private let sortToggleButton = SortToggleControl()
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
        
        
    }
    
    func configureHierarchy() {
        view.addSubviews([sortToggleButton/*, collectionView*/])
    }
    
    func configureConstraints() {
        
        sortToggleButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
