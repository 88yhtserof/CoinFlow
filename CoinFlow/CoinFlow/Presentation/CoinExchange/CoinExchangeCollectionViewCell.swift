//
//  CoinExchangeCollectionViewCell.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/7/25.
//

import UIKit

final class CoinExchangeCollectionViewCell: UICollectionViewCell, BaseCollectionViewCell {
    
    static let identifier = String(describing: CoinExchangeCollectionViewCell.self)
    
    private let marketLabel = UILabel()
    private let tradePriceLabel = UILabel()
    private let changeRateLabel = UILabel()
    private let changePriceLabel = UILabel()
    private lazy var changeStckView = UIStackView(arrangedSubviews: [changeRateLabel, changePriceLabel])
    private let accTradePriceLabel = UILabel()
    private lazy var priceStackView = UIStackView(arrangedSubviews: [tradePriceLabel, changeStckView, accTradePriceLabel])
    
    var tradePrice: Double = 0.0 {
        didSet {
            tradePriceLabel.text = CoinNumberFormatter.tradePrice(number: tradePrice).string
        }
    }
    
    var changeRate: Double = 0.0 {
        didSet {
            changeRateLabel.text = CoinNumberFormatter.changeRate(number: changeRate).string
            configureChangeLabelColor()
        }
    }
    
    var changePrice: Double = 0.0 {
        didSet {
            changePriceLabel.text = CoinNumberFormatter.changePrice(number: changePrice).string
        }
    }
    
    var accTradePrice: Double = 0.0 {
        didSet {
            accTradePriceLabel.text = CoinNumberFormatter.accTradePrice(number: accTradePrice).string
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with value: MarketTickerResponse) {
        marketLabel.text = value.market
        tradePrice = value.trade_price
        changeRate = value.signed_change_rate
        changePrice = value.signed_change_price
        accTradePrice = value.acc_trade_price
    }
}

//MARK: - Configuration
private extension CoinExchangeCollectionViewCell {
    
    func configureChangeLabelColor() {
        changeStckView.arrangedSubviews
            .compactMap{ $0 as? UILabel }
            .forEach{
                if changeRate > 0 {
                    $0.textColor = CoinFlowColor.rise
                } else if changeRate < 0 {
                    $0.textColor = CoinFlowColor.fall
                } else {
                    $0.textColor = CoinFlowColor.title
                }
            }
    }
    
    func configureView() {
        marketLabel.text = "코인"
        marketLabel.font = .systemFont(ofSize: 12, weight: .bold)
        marketLabel.textColor = CoinFlowColor.title
        
        [ tradePriceLabel, changeRateLabel, changePriceLabel, accTradePriceLabel ]
            .forEach{ label in
                label.font = .systemFont(ofSize: 12, weight: .regular)
                label.textColor = CoinFlowColor.title
            }
        changePriceLabel.font = .systemFont(ofSize: 9, weight: .regular)
        
        tradePriceLabel.text = "3,868"
        changeRateLabel.text = "-123%"
        changePriceLabel.text = "-703,000"
        accTradePriceLabel.text = "123,456"
        
        changeStckView.axis = .vertical
        changeStckView.alignment = .trailing
        priceStackView.distribution = .fillEqually
        
        priceStackView.axis = .horizontal
        priceStackView.distribution = .equalCentering
        priceStackView.alignment = .top
    }
    
    func configureHierarchy() {
        contentView.addSubviews([marketLabel, priceStackView])
    }
    
    func configureConstraints() {
        
        let verticalInset: CGFloat = 10
        let horizontalInset: CGFloat = 15
        
        marketLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(verticalInset)
            make.leading.equalToSuperview().inset(horizontalInset)
        }
        
        priceStackView.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.verticalEdges.equalToSuperview().inset(verticalInset)
            make.trailing.equalToSuperview().inset(horizontalInset)
            make.leading.greaterThanOrEqualTo(marketLabel.snp.trailing).offset(50)
        }
    }
}
