//
//  TrendingSearchKeywordCollectionViewCell.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/8/25.
//

import UIKit

import SnapKit

final class TrendingSearchKeywordCollectionViewCell: UICollectionViewCell, BaseCollectionViewCell {
    
    static let identifier = String(describing: TrendingSearchKeywordCollectionViewCell.self)
    
    private let rankLabel = UILabel()
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let symbolLabel = UILabel()
    private lazy var nameStackView = UIStackView(arrangedSubviews: [nameLabel, symbolLabel])
    private let changeImageView = UIImageView()
    private let changeLabel = UILabel()
    private lazy var changeStackView = UIStackView(arrangedSubviews: [changeImageView, changeLabel])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with value: String) {
        rankLabel.text = value
    }
}

//MARK: - Configuration
private extension TrendingSearchKeywordCollectionViewCell {
    
    func configureView() {
        rankLabel.text = "1"
        rankLabel.textColor = CoinFlowColor.title
        rankLabel.font = .systemFont(ofSize: 12, weight: .regular)
        rankLabel.textAlignment = .center
        
        iconImageView.image = UIImage(systemName: "photo.circle")
        iconImageView.tintColor = CoinFlowColor.subtitle
        
        nameLabel.text = "COIN"
        nameLabel.textColor = CoinFlowColor.title
        nameLabel.font = .systemFont(ofSize: 12, weight: .bold)
        
        symbolLabel.text = "Flow"
        symbolLabel.textColor = CoinFlowColor.subtitle
        symbolLabel.font = .systemFont(ofSize: 9, weight: .regular)
        
        nameStackView.axis = .vertical
        nameStackView.spacing = 0
        nameStackView.alignment = .leading
        
        changeImageView.image = UIImage(systemName: "arrowtriangle.up.fill")
        changeImageView.tintColor = CoinFlowColor.title
        
        changeLabel.text = "1.23%"
        changeLabel.textColor = CoinFlowColor.title
        changeLabel.font = .systemFont(ofSize: 9, weight: .bold)
        changeLabel.textAlignment = .right
        
        changeStackView.axis = .horizontal
        changeStackView.spacing = 2
        changeStackView.alignment = .center
    }
    
    func configureHierarchy() {
        contentView.addSubviews([rankLabel, iconImageView, nameStackView, changeStackView])
    }
    
    func configureConstraints() {
        
        let inset: CGFloat = 14
        let offset: CGFloat = 4
        
        
        rankLabel.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(inset)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(26)
            make.centerY.equalToSuperview()
            make.leading.equalTo(rankLabel.snp.trailing).offset(offset)
        }
        
        nameStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(offset)
        }
        
        changeImageView.snp.makeConstraints { make in
            make.size.equalTo(9)
        }
        
        changeStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(nameLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(inset)
        }
        
    }
}
