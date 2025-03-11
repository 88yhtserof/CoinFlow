//
//  ChartCollectionViewCell.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/11/25.
//

import UIKit

import SnapKit
import DGCharts

final class ChartCollectionViewCell: UICollectionViewCell, BaseCollectionViewCell {
    
    static let identifier = String(describing: CoinListCollectionViewCell.self)
    
    private let currentPriceLabel = UILabel()
    private let changeImageView = UIImageView()
    private let changeLabel = UILabel()
    private lazy var changeStackView = UIStackView(arrangedSubviews: [changeImageView, changeLabel])
    private lazy var priceStackView = UIStackView(arrangedSubviews: [currentPriceLabel, changeStackView])
    
    private lazy var chartView = LineChartView()
    
    private let updatedDateLabel = UILabel()
    
    private var chartDataEntries: [ChartDataEntry] = []
    
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
        
        chartDataEntries = value.sparkline_in_7d.price
            .enumerated()
            .filter{ $0.0.isMultiple(of: 3) }
            .map { (x, y) in
                ChartDataEntry(x: Double(x), y: y)
            }
        
        setData()
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
        
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.legend.enabled = false
        chartView.chartDescription.enabled = false
        chartView.pinchZoomEnabled = false
        chartView.dragEnabled = false
        
    }
    
    func configureHierarchy() {
        contentView.addSubviews([priceStackView, chartView, updatedDateLabel])
    }
    
    func configureConstraints() {
        
        priceStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(priceStackView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
        }
        
        updatedDateLabel.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).offset(8)
            make.leading.bottom.equalToSuperview()
        }
    }
}

//MARK: - Chart
extension ChartCollectionViewCell: ChartViewDelegate {
    
    func setData() {
        let set = LineChartDataSet(entries: chartDataEntries, label: "")
        set.drawCirclesEnabled = false
        set.mode = .cubicBezier
        set.lineWidth = 2
        set.setColor(CoinFlowColor.chart)
        
        let colorTop =  UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 49.0/255.0, green: 130.0/255.0, blue: 246.0/255.0, alpha: 1.0).cgColor

        let gradientColors = [colorTop, colorBottom] as CFArray
        let colorLocations:[CGFloat] = [0.0, 1.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        set.fill = LinearGradientFill(gradient: gradient!, angle: 90.0)
        set.fillAlpha = 0.8
        set.drawFilledEnabled = true
        set.drawValuesEnabled = false
        
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        chartView.data = data
    }
}
