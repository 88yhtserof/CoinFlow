//
//  ExchangeBar.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/7/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class ExchangeBar: UIControl {
    
    enum Sort {
        case tradePrice(SortToggleControl.SortType)
        case changePrice(SortToggleControl.SortType)
        case accTradePrice(SortToggleControl.SortType)
    }

    private let titleLabel = UILabel()
    private let tradePriceToggle = SortToggleControl()
    private let changePriceToggle = SortToggleControl()
    private let accTradePriceToggle = SortToggleControl()
    private lazy var toggleStackView = UIStackView(arrangedSubviews: [tradePriceToggle, changePriceToggle, accTradePriceToggle])
    
    private let disposeBag = DisposeBag()
    
    private(set) var sort: Sort = .accTradePrice(.desc)
    
    init() {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureConstraints()
        configureView()
        
        tradePriceToggle.rx.valueChanged
            .bind(with: self, onNext: { owner, sortType in
                owner.toggleStackView.arrangedSubviews
                    .filter{ $0 != owner.tradePriceToggle }
                    .compactMap{ $0 as? SortToggleControl }
                    .forEach { toggle in
                        toggle.sortType = .none
                    }
                owner.sort = .tradePrice(sortType)
                owner.sendActions(for: .valueChanged)
            })
            .disposed(by: disposeBag)
        
        changePriceToggle.rx.valueChanged
            .bind(with: self, onNext: { owner, sortType in
                owner.toggleStackView.arrangedSubviews
                    .filter{ $0 != owner.changePriceToggle }
                    .compactMap{ $0 as? SortToggleControl }
                    .forEach { toggle in
                        toggle.sortType = .none
                    }
                owner.sort = .changePrice(sortType)
                owner.sendActions(for: .valueChanged)
            })
            .disposed(by: disposeBag)
        
        accTradePriceToggle.rx.valueChanged
            .bind(with: self, onNext: { owner, sortType in
                owner.toggleStackView.arrangedSubviews
                    .filter{ $0 != owner.accTradePriceToggle }
                    .compactMap{ $0 as? SortToggleControl }
                    .forEach { toggle in
                        toggle.sortType = .none
                    }
                owner.sort = .accTradePrice(sortType)
                owner.sendActions(for: .valueChanged)
            })
            .disposed(by: disposeBag)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configuration
private extension ExchangeBar {
    
    func configureView() {
        backgroundColor = CoinFlowColor.subBackground
        
        titleLabel.text = "코인"
        titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        
        toggleStackView.arrangedSubviews
            .compactMap{ $0 as? SortToggleControl }
            .forEach{ toggle in
                toggle.font = .systemFont(ofSize: 12, weight: .bold)
            }
        
        tradePriceToggle.title = "현재가"
        changePriceToggle.title = "전일대비"
        accTradePriceToggle.title = "거래대금"
        
        toggleStackView.axis = .horizontal
        toggleStackView.distribution = .equalCentering
        toggleStackView.alignment = .center
    }
    
    func configureHierarchy() {
        addSubviews([titleLabel, toggleStackView])
    }
    
    func configureConstraints() {
        
        let verticalInset: CGFloat = 10
        let horizontalInset: CGFloat = 15
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(verticalInset)
            make.leading.equalToSuperview().inset(horizontalInset)
        }
        
        toggleStackView.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.verticalEdges.equalToSuperview().inset(verticalInset)
            make.trailing.equalToSuperview().inset(horizontalInset)
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(50)
        }
    }
}

//MARK: - Reactive
extension Reactive where Base: ExchangeBar {
    
    var sort: ControlEvent<ExchangeBar.Sort> {
        let source = controlEvent(.valueChanged)
            .map{ _ in base.sort }
        
        return ControlEvent(events: source)
    }
}
