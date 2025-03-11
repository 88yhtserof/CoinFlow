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
    
    func configure(with value: String) {
        
    }
}

//MARK: - Configuration
private extension ChartCollectionViewCell {
    
    func configureView() {
        
        currentPriceLabel.text = String(format: "₩%@", CoinNumberFormatter.currentPrice(number: 10000).string ?? "")
        
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
