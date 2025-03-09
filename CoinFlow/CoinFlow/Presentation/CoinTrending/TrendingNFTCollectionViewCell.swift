//
//  TrendingNFTCollectionViewCell.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/9/25.
//

import UIKit

import SnapKit

final class TrendingNFTCollectionViewCell: UICollectionViewCell, BaseCollectionViewCell {
    
    static let identifier = String(describing: TrendingNFTCollectionViewCell.self)
    
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let floorPrice = UILabel()
    private lazy var nameStackView = UIStackView(arrangedSubviews: [nameLabel, floorPrice])
    private let changeImageView = UIImageView()
    private let changeLabel = UILabel()
    private lazy var changeStackView = UIStackView(arrangedSubviews: [changeImageView, changeLabel])
    private lazy var outerStackView = UIStackView(arrangedSubviews: [iconImageView, nameStackView, changeStackView])
    
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
        
    }
}

//MARK: - Configuration
private extension TrendingNFTCollectionViewCell {
    
    func configureView() {
        
        iconImageView.image = UIImage(systemName: "photo.circle")
        iconImageView.tintColor = CoinFlowColor.subtitle
        
        nameLabel.text = "COIN"
        nameLabel.textColor = CoinFlowColor.title
        nameLabel.font = .systemFont(ofSize: 9, weight: .bold)
        
        floorPrice.text = "Flow"
        floorPrice.textColor = CoinFlowColor.subtitle
        floorPrice.font = .systemFont(ofSize: 9, weight: .regular)
        
        nameStackView.axis = .vertical
        nameStackView.spacing = 0
        nameStackView.alignment = .center
        
        changeImageView.image = UIImage(systemName: "arrowtriangle.up.fill")
        changeImageView.tintColor = CoinFlowColor.title
        
        changeLabel.text = "1.23%"
        changeLabel.textColor = CoinFlowColor.title
        changeLabel.font = .systemFont(ofSize: 9, weight: .bold)
        changeLabel.textAlignment = .right
        
        changeStackView.axis = .horizontal
        changeStackView.spacing = 2
        changeStackView.distribution = .equalSpacing
        
        outerStackView.axis = .vertical
        outerStackView.spacing = 5
        outerStackView.alignment = .center
    }
    
    func configureHierarchy() {
        contentView.addSubviews([outerStackView])
    }
    
    func configureConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.width.equalTo(iconImageView.snp.height)
        }
        
        changeImageView.snp.makeConstraints { make in
            make.width.equalTo(9)
        }
        
        changeStackView.snp.makeConstraints { make in
            make.height.equalTo(9)
        }
        
        outerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
