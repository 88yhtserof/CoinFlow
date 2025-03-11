//
//  CoinInfoCollectionViewCell.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/11/25.
//

import UIKit

import SnapKit

final class CoinInfoCollectionViewCell: CoinBaseCollectionViewCell, BaseCollectionViewCell {
    
    static let identifier = String(describing: CoinInfoCollectionViewCell.self)
    
    private let low24hInfoView = InfoView()
    private let high24hInfoView = InfoView()
    private let athInfoView = InfoView()
    private let atlInfoView = InfoView()
    
    private lazy var leftVerticalStackView = UIStackView(arrangedSubviews: [high24hInfoView, athInfoView])
    private lazy var rightVerticalStackView = UIStackView(arrangedSubviews: [low24hInfoView, atlInfoView])
    private lazy var horizontalStackView = UIStackView(arrangedSubviews: [leftVerticalStackView, rightVerticalStackView])
    
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
        high24hInfoView.valueLabel.text = String(format: "₩%@", CoinNumberFormatter.currentPrice(number: Int(value.high_24h)).string ?? "")
        
        low24hInfoView.valueLabel.text = String(format: "₩%@", CoinNumberFormatter.currentPrice(number: Int(value.low_24h)).string ?? "")
        
        athInfoView.valueLabel.text = String(format: "₩%@", CoinNumberFormatter.currentPrice(number: Int(value.ath)).string ?? "")
        athInfoView.dateLabel.text = CoinDateFomatter.detailInfo(CoinDateFomatter.responseDate(value.ath_date).date ?? Date()).string
        
        atlInfoView.valueLabel.text = String(format: "₩%@", CoinNumberFormatter.currentPrice(number: Int(value.atl)).string ?? "")
        atlInfoView.dateLabel.text = CoinDateFomatter.detailInfo(CoinDateFomatter.responseDate(value.atl_date).date ?? Date()).string
    }
}

//MARK: - Configuration
private extension CoinInfoCollectionViewCell {
    
    func configureView() {
        
        high24hInfoView.titleLabel.text = "24시간 고가"
        high24hInfoView.valueLabel.text = String(format: "₩%@", CoinNumberFormatter.currentPrice(number: 142060908).string ?? "")
        
        low24hInfoView.titleLabel.text = "24시간 저가"
        low24hInfoView.valueLabel.text = String(format: "₩%@", CoinNumberFormatter.currentPrice(number: 142060908).string ?? "")
        
        athInfoView.titleLabel.text = "역대 최고가"
        athInfoView.valueLabel.text = String(format: "₩%@", CoinNumberFormatter.currentPrice(number: 142060908).string ?? "")
        athInfoView.dateLabel.text = CoinDateFomatter.detailInfo(Date()).string
        
        atlInfoView.titleLabel.text = "역대 최저가"
        atlInfoView.valueLabel.text = String(format: "₩%@", CoinNumberFormatter.currentPrice(number: 142060908).string ?? "")
        atlInfoView.dateLabel.text = CoinDateFomatter.detailInfo(Date()).string
        
        [ leftVerticalStackView, rightVerticalStackView ]
            .forEach {
                $0.axis = .vertical
                $0.spacing = 2
                $0.alignment = .leading
                $0.distribution = .equalSpacing
            }
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
    }
    
    func configureHierarchy() {
        contentView.addSubviews([horizontalStackView])
    }
    
    func configureConstraints() {
        
        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}
