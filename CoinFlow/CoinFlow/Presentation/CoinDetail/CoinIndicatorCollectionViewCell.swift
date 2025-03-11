//
//  CoinIndicatorCollectionViewCell.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/11/25.
//

import UIKit

import SnapKit

final class CoinIndicatorCollectionViewCell: CoinBaseCollectionViewCell, BaseCollectionViewCell {
    
    static let identifier = String(describing: CoinInfoCollectionViewCell.self)
    
    private let marketCapInfoView = InfoView()
    private let fullyDilutedValuationInfoView = InfoView()
    private let totalVolumeInfoView = InfoView()
    
    private lazy var verticalStackView = UIStackView(arrangedSubviews: [marketCapInfoView, fullyDilutedValuationInfoView, totalVolumeInfoView])
    
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
        marketCapInfoView.valueLabel.text = String(format: "₩%@", CoinNumberFormatter.currentPrice(number: Int(value.market_cap)).string ?? "")
        fullyDilutedValuationInfoView.valueLabel.text = String(format: "₩%@", CoinNumberFormatter.currentPrice(number: value.fully_diluted_valuation).string ?? "")
        totalVolumeInfoView.valueLabel.text = String(format: "₩%@", CoinNumberFormatter.currentPrice(number: value.total_volume).string ?? "")
    }
}

//MARK: - Configuration
private extension CoinIndicatorCollectionViewCell {
    
    func configureView() {
        
        marketCapInfoView.titleLabel.text = "시가총액"
        marketCapInfoView.valueLabel.text = String(format: "₩%@", CoinNumberFormatter.currentPrice(number: 142060908).string ?? "")
        
        fullyDilutedValuationInfoView.titleLabel.text = "완전 희석 가치(FDV)"
        fullyDilutedValuationInfoView.valueLabel.text = String(format: "₩%@", CoinNumberFormatter.currentPrice(number: 142060908).string ?? "")
        
        totalVolumeInfoView.titleLabel.text = "총 거래량"
        totalVolumeInfoView.valueLabel.text = String(format: "₩%@", CoinNumberFormatter.currentPrice(number: 142060908).string ?? "")

        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.alignment = .leading
        verticalStackView.distribution = .equalSpacing
    }
    
    func configureHierarchy() {
        contentView.addSubviews([verticalStackView])
    }
    
    func configureConstraints() {
        
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}
