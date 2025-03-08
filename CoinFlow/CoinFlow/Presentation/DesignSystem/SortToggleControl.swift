//
//  SortToggleControl.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/6/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class SortToggleControl: UIControl {
    
    enum SortType: Int, CaseIterable {
        case none
        case desc
        case asc
    }
    
    private let titleLabel = UILabel()
    private let ascImageView = UIImageView()
    private let descImageView = UIImageView()
    private lazy var sortStackView = UIStackView(arrangedSubviews: [ascImageView, descImageView])
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var font: UIFont? {
        get { titleLabel.font }
        set { titleLabel.font = newValue }
    }
    
    var sortType: SortType = .none {
        didSet {
            switch sortType {
            case .none:
                ascImageView.tintColor = CoinFlowColor.subtitle
                descImageView.tintColor = CoinFlowColor.subtitle
            case .desc:
                ascImageView.tintColor = CoinFlowColor.subtitle
                descImageView.tintColor = CoinFlowColor.title
            case .asc:
                ascImageView.tintColor = CoinFlowColor.title
                descImageView.tintColor = CoinFlowColor.subtitle
            }
        }
    }
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        sortType = SortType(rawValue: (sortType.rawValue + 1) % SortType.allCases.count) ?? .none
    }
}

//MARK: - Configuration
private extension SortToggleControl {
    
    func configureView() {
        
        titleLabel.text = "정렬"
        titleLabel.textColor = CoinFlowColor.title
        
        ascImageView.image = UIImage(systemName: "arrowtriangle.up.fill")
        ascImageView.tintColor = CoinFlowColor.subtitle
        ascImageView.contentMode = .scaleAspectFill
        
        descImageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        descImageView.tintColor = CoinFlowColor.subtitle
        descImageView.contentMode = .scaleAspectFill
        
        sortStackView.axis = .vertical
        sortStackView.spacing = 2
        sortStackView.distribution = .fillEqually
    }
    
    func configureHierarchy() {
        addSubviews([titleLabel, sortStackView])
    }
    
    func configureConstraints() {
        let height: CGFloat = 15
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
            make.height.equalTo(height)
        }
        
        sortStackView.snp.makeConstraints { make in
            make.height.equalTo(titleLabel)
            make.width.equalTo(height / 2.0)
            make.leading.equalTo(titleLabel.snp.trailing)
            make.trailing.equalToSuperview()
        }
    }
}

//MARK: - Reactive
extension Reactive where Base: SortToggleControl {
    
    var valueChanged: ControlEvent<SortToggleControl.SortType> {
        let source = controlEvent(.touchUpInside)
            .map { _ in base.sortType }
        return ControlEvent(events: source)
    }
}
