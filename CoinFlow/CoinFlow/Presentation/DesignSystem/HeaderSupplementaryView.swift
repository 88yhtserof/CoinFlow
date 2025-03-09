//
//  HeaderSupplementaryView.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/9/25.
//

import UIKit

import SnapKit

final class HeaderSupplementaryView: UICollectionReusableView {
    
    private let titleLabel = UILabel()
    let accessoryLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        accessoryLabel.isHidden = true
    }
    
    func configure(with string: String) {
        titleLabel.text = string
    }
}

//MARK: - Configuration
private extension HeaderSupplementaryView {
    private func configureViews() {
        titleLabel.textColor = CoinFlowColor.title
        titleLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        
        accessoryLabel.textColor = CoinFlowColor.subtitle
        accessoryLabel.font = .systemFont(ofSize: 12, weight: .regular)
        accessoryLabel.isHidden = true
    }
    
    private func configureHierarchy() {
        addSubviews([titleLabel, accessoryLabel])
    }
    
    private func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        accessoryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
