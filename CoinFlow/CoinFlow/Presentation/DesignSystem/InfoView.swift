//
//  InfoView.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/11/25.
//

import UIKit

final class InfoView: UIView {
    
    let titleLabel = UILabel()
    let valueLabel = UILabel()
    let dateLabel = UILabel()
    private lazy var stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel, dateLabel])
    
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
private extension InfoView {
    
    func configureView() {
        
        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        titleLabel.textColor = CoinFlowColor.subtitle
        
        valueLabel.font = .systemFont(ofSize: 12, weight: .regular)
        valueLabel.textColor = CoinFlowColor.title
        
        dateLabel.font = .systemFont(ofSize: 9, weight: .regular)
        dateLabel.textColor = CoinFlowColor.subtitle
        
        [ titleLabel, valueLabel, dateLabel ]
            .forEach{ $0.textAlignment = .left }
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
    }
    
    func configureHierarchy() {
        addSubviews([stackView])
    }
    
    func configureConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
