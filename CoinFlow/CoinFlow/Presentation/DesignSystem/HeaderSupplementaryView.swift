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
    let accessoryButton = UIButton()
    
    var accessoryButtonConfiguration: UIButton.Configuration? {
        get { accessoryButton.configuration }
        set {
            accessoryButton.isHidden = false
            accessoryButton.configuration = newValue
        }
    }
    
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
        accessoryButton.isHidden = true
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
        
        accessoryButton.isHidden = true
    }
    
    private func configureHierarchy() {
        addSubviews([titleLabel, accessoryButton])
    }
    
    private func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        accessoryButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview()
        }
    }
}
