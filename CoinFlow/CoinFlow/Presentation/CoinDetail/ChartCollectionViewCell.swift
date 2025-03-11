//
//  ChartCollectionViewCell.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/11/25.
//

import UIKit

import SnapKit

final class ChartCollectionViewCell: UICollectionViewCell, BaseCollectionViewCell {
    
    static let identifier = String(describing: CoinListCollectionViewCell.self)
    
    private let currentPriceLabel = UILabel()
    private let changeImageView = UIImageView()
    private let changeLabel = UILabel()
    private lazy var changeStackView = UIStackView(arrangedSubviews: [changeImageView, changeLabel])
    private lazy var priceStackView = UIStackView(arrangedSubviews: [currentPriceLabel, changeStackView])
    
    // chart view 생성
    
    private let updatedDateLabel = UILabel()
    
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
    
    func configure(with value: CoingeckoCoinsMarket) {
        currentPriceLabel.text = String(format: "₩%@", CoinNumberFormatter.currentPrice(number: Int(value.current_price)).string ?? "")
        
        let change_Percentage = value.price_change_percentage_24h
        let change_Percentage_String = CoinNumberFormatter.changeRate(number: change_Percentage).string
        changeLabel.text = change_Percentage_String
        changeImageView.image = UIImage(systemName:  value.price_change_percentage_24h > 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
        
        if change_Percentage > 0 {
            changeLabel.textColor = CoinFlowColor.rise
            changeImageView.tintColor = CoinFlowColor.rise
        } else if change_Percentage < 0 {
            changeLabel.textColor = CoinFlowColor.fall
            changeImageView.tintColor = CoinFlowColor.fall
        } else {
            changeLabel.textColor = CoinFlowColor.title
            changeImageView.tintColor = .clear
        }
        
        updatedDateLabel.text = CoinDateFomatter.detailUpdating(Date()).string
    }
}

//MARK: - Configuration
private extension ChartCollectionViewCell {
    
    func configureView() {
        
        currentPriceLabel.text = String(format: "₩%@", CoinNumberFormatter.tradePrice(number: 10000).string ?? "")
        
        changeImageView.image = UIImage(systemName: "arrowtriangle.up.fill")
        changeImageView.tintColor = CoinFlowColor.title
        
        changeLabel.text = "1.23%"
        changeLabel.textColor = CoinFlowColor.title
        changeLabel.font = .systemFont(ofSize: 9, weight: .bold)
        changeLabel.textAlignment = .right
        
        changeStackView.axis = .horizontal
        changeStackView.spacing = 2
        changeStackView.distribution = .equalSpacing
        
        priceStackView.axis = .vertical
        priceStackView.spacing = 2
        priceStackView.alignment = .leading
        
        updatedDateLabel.text = CoinDateFomatter.detailUpdating(Date()).string
        updatedDateLabel.textColor = CoinFlowColor.subtitle
        updatedDateLabel.font = .systemFont(ofSize: 9, weight: .regular)
    }
    
    func configureHierarchy() {
        contentView.addSubviews([priceStackView, /* chartView ,*/ updatedDateLabel])
    }
    
    func configureConstraints() {
        
        priceStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        updatedDateLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
        }
    }
}
