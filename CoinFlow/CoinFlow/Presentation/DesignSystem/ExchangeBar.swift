//
//  ExchangeBar.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/7/25.
//

import UIKit

final class ExchangeBar: UIView {

    private let titleLabel = UILabel()
    private let tradePriceToggle = SortToggleControl()
    private let changePriceToggle = SortToggleControl()
    private let accTradePriceToggle = SortToggleControl()
    private lazy var toggleStackView = UIStackView(arrangedSubviews: [tradePriceToggle, changePriceToggle, accTradePriceToggle])
    
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
private extension ExchangeBar {
    
    func configureView() {
        backgroundColor = CoinFlowColor.subBackground
        
        titleLabel.text = "코인"
        titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        
        toggleStackView.arrangedSubviews
            .compactMap{ $0 as? SortToggleControl }
            .forEach{ toggle in
                toggle.font = .systemFont(ofSize: 12, weight: .bold)
            }
        
        tradePriceToggle.title = "현재가"
        changePriceToggle.title = "전일대비"
        accTradePriceToggle.title = "거래대금"
        
        toggleStackView.axis = .horizontal
        toggleStackView.distribution = .equalCentering
        toggleStackView.alignment = .center
    }
    
    func configureHierarchy() {
        addSubviews([titleLabel, toggleStackView])
    }
    
    func configureConstraints() {
        
        let verticalInset: CGFloat = 10
        let horizontalInset: CGFloat = 15
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(verticalInset)
            make.leading.equalToSuperview().inset(horizontalInset)
        }
        
        toggleStackView.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.verticalEdges.equalToSuperview().inset(verticalInset)
            make.trailing.equalToSuperview().inset(horizontalInset)
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(50)
        }
    }
}
