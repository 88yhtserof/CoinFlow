//
//  CoinTrendingViewController.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/6/25.
//

import UIKit

final class CoinTrendingViewController: UIViewController {
    
    private let searchBar = SearchBar()
    
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
        view.addSubviews([searchBar])
    }
    
    func configureConstraints() {
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
}
