//
//  IconTitleView.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/11/25.
//

import UIKit

import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class IconTitleView: UIView {
    
    private let iconImageView = UIImageView()
    let symbolLabel = UILabel()
    private lazy var symbolStackView = UIStackView(arrangedSubviews: [iconImageView, symbolLabel])
    
    init() {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(string: String) {
        if let url = URL(string: string) {
            iconImageView.kf.setImage(with: url)
        }
    }
}

//MARK: - Configuration
private extension IconTitleView {
    
    func configureView() {
        
        iconImageView.image = UIImage(systemName: "photo.circle")
        iconImageView.tintColor = CoinFlowColor.subtitle
        iconImageView.cornerRadius(26.0 / 2.0)
        
        symbolLabel.text = "COIN"
        symbolLabel.textColor = CoinFlowColor.title
        symbolLabel.font = .systemFont(ofSize: 12, weight: .bold)
        
        symbolStackView.axis = .horizontal
        symbolStackView.spacing = 8
    }
    
    func configureHierarchy() {
        addSubviews([symbolStackView])
    }
    
    func configureConstraints() {
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(26)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        symbolStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension Reactive where Base: IconTitleView {
    var title: Binder<String?> {
        base.symbolLabel.rx.text
    }
}
