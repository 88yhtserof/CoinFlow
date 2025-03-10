//
//  CoinListCollectionViewCell.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/10/25.
//

import UIKit

final class CoinListCollectionViewCell: UICollectionViewCell, BaseCollectionViewCell {
    
    static let identifier = String(describing: CoinListCollectionViewCell.self)
    
    private let iconImageView = UIImageView()
    private let symbolLabel = UILabel()
    private let rankMarkView = RankMarkView()
    private lazy var symbolStackView = UIStackView(arrangedSubviews: [symbolLabel, rankMarkView])
    private let nameLabel = UILabel()
    private lazy var nameStackView = UIStackView(arrangedSubviews: [symbolStackView, nameLabel])
    private lazy var favoriteButton = FavoriteButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = UIImage(systemName: "photo.circle")
    }
    
    func configure(with value: String) {
        
    }
}

//MARK: - Configuration
private extension CoinListCollectionViewCell {
    
    func configureView() {
        
        iconImageView.image = UIImage(systemName: "photo.circle")
        iconImageView.tintColor = CoinFlowColor.subtitle
        iconImageView.cornerRadius(36.0 / 2.0)
        
        symbolLabel.text = "COIN"
        symbolLabel.textColor = CoinFlowColor.title
        symbolLabel.font = .systemFont(ofSize: 12, weight: .bold)
        
        rankMarkView.text = "100"
        
        symbolStackView.axis = .horizontal
        symbolStackView.spacing = 8
        
        nameLabel.text = "Flow"
        nameLabel.textColor = CoinFlowColor.subtitle
        nameLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        nameStackView.axis = .vertical
        nameStackView.spacing = 0
        nameStackView.alignment = .leading
    }
    
    func configureHierarchy() {
        contentView.addSubviews([iconImageView, nameStackView, favoriteButton])
    }
    
    func configureConstraints() {
        
        let inset: CGFloat = 12
        let offset: CGFloat = 4
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(inset)
        }
        
        nameStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(inset)
            make.leading.equalTo(iconImageView.snp.trailing).offset(offset)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.size.equalTo(26)
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(nameStackView.snp.trailing).offset(offset)
            make.trailing.equalToSuperview().inset(inset)
        }
    }
}
