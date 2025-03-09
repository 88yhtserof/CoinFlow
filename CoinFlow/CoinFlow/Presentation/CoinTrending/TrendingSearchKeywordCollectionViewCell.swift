//
//  TrendingSearchKeywordCollectionViewCell.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/8/25.
//

import UIKit

import SnapKit
import Kingfisher

final class TrendingSearchKeywordCollectionViewCell: UICollectionViewCell, BaseCollectionViewCell {
    
    static let identifier = String(describing: TrendingSearchKeywordCollectionViewCell.self)
    
    private let rankLabel = UILabel()
    private let iconImageView = UIImageView()
    private let symbolLabel = UILabel()
    private let nameLabel = UILabel()
    private lazy var nameStackView = UIStackView(arrangedSubviews: [symbolLabel, nameLabel])
    private var changeImageView = UIImageView()
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
    
    func configure(with value: (Int, CoingeckoTrendingCoin)) {
        let (rank, coin) = value
        rankLabel.text = String(rank + 1)
        symbolLabel.text = coin.item.symbol
        nameLabel.text = coin.item.name
        
        if let url = URL(string: coin.item.small) {
            iconImageView.kf.setImage(with: url)
        }
        
        let change_Percentage = CoinNumberFormatter.changeRate(number: coin.item.data.price_change_percentage_24h.krw).string
        changeLabel.text = change_Percentage
        changeImageView.image = UIImage(systemName:  coin.item.data.price_change_percentage_24h.krw > 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
        
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
        iconImageView.cornerRadius(26.0 / 2.0)
        
        symbolLabel.text = "COIN"
        symbolLabel.textColor = CoinFlowColor.title
        symbolLabel.font = .systemFont(ofSize: 12, weight: .bold)
        
        nameLabel.text = "Flow"
        nameLabel.textColor = CoinFlowColor.subtitle
        nameLabel.font = .systemFont(ofSize: 9, weight: .regular)
        
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
        
        let inset: CGFloat = 4
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
            make.leading.greaterThanOrEqualTo(nameStackView.snp.trailing).offset(offset)
            make.trailing.equalToSuperview().inset(inset)
        }
        
    }
}
