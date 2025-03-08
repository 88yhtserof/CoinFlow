//
//  SearchBar.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/8/25.
//

import UIKit

import SnapKit

class SearchBar: UIView {
    
    private let backgroundView = UIView()
    private let iconImageView = UIImageView()
    let searchTextField = UITextField()
    
    init() {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Configuration
private extension SearchBar {
    
    func configureView() {
        backgroundView.backgroundColor = CoinFlowColor.background
        backgroundView.cornerRadius(20)
        backgroundView.border(color: CoinFlowColor.subtitle)
        
        iconImageView.image = UIImage(systemName: "magnifyingglass")
        iconImageView.tintColor = CoinFlowColor.subtitle
        
        searchTextField.placeholder = "검색어를 입력해주세요."
        searchTextField.textColor = CoinFlowColor.title
        searchTextField.font = .systemFont(ofSize: 14, weight: .regular)
    }
    
    func configureHierarchy() {
        addSubviews([backgroundView])
        backgroundView.addSubviews([iconImageView, searchTextField])
    }
    
    func configureConstraints() {
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(40)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
        }
    }
}

