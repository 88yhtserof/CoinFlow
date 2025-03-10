//
//  RankMarkView.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/10/25.
//

import UIKit

import SnapKit

final class RankMarkView: UIView {
    
    private let textLabel = UILabel()
    
    var text: String? {
        get {
            textLabel.text
        }
        set {
            textLabel.text = String(format: "#%@", newValue ?? "")
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
}

//MARK: - Configuration
private extension RankMarkView {
    
    func configureView() {
        backgroundColor = CoinFlowColor.subBackground
        cornerRadius(3)
        
        textLabel.font = .systemFont(ofSize: 9, weight: .bold)
        textLabel.textColor = CoinFlowColor.subtitle
    }
    
    func configureHierarchy() {
        addSubviews([textLabel])
    }
    
    func configureConstraints() {
        
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
}
