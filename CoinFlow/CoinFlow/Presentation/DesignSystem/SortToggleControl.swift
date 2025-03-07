//
//  SortToggleControl.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/6/25.
//

import UIKit

import SnapKit

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
    
    private var sortNumber: Int = SortType.none.rawValue {
        didSet {
            sortType = SortType(rawValue: sortNumber)!
        }
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
        sortNumber = (sortNumber + 1) % SortType.allCases.count
    }
}

//MARK: - Configuration
private extension SortToggleControl {
    
    func configureView() {
        
        titleLabel.text = "정렬"
        titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        
        ascImageView.image = UIImage(systemName: "arrowtriangle.up.fill")
        ascImageView.tintColor = CoinFlowColor.subtitle
        ascImageView.contentMode = .scaleAspectFill
        
        descImageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        descImageView.tintColor = CoinFlowColor.subtitle
        descImageView.contentMode = .scaleAspectFill
        
        sortStackView.axis = .vertical
        sortStackView.spacing = 1
        sortStackView.distribution = .fillEqually
    }
    
    func configureHierarchy() {
        addSubviews([titleLabel, sortStackView])
    }
    
    func configureConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
            make.height.equalTo(18)
        }
        
        sortStackView.snp.makeConstraints { make in
            make.height.equalTo(titleLabel)
            make.width.equalTo(10)
            make.leading.equalTo(titleLabel.snp.trailing)
            make.trailing.equalToSuperview()
        }
    }
}
