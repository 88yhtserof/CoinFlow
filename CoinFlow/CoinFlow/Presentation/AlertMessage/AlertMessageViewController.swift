//
//  AlertMessageViewController.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/19/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class AlertMessageViewController: UIViewController {
    
    private let deemBackgroundView = UIView()
    private let alertBackgroundView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private lazy var alertStackView = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
    private let button = UIButton()
    
    var message: String? {
        get { messageLabel.text }
        set { messageLabel.text = newValue }
    }
    
    var buttonTitle: String? {
        get { button.title(for: .normal) }
        set { button.setTitle(newValue, for: .normal) }
    }
    
    var buttonHandler: (() -> Void)?
    
    private let networkMonitor = NetworkMonitor()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureConstraints()
        configureView()
        
        button.rx.tap
            .withLatestFrom(networkMonitor.isConnected)
            .bind(with: self) { owner, isConnected in
                if isConnected {
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func didButtonTapped() {
        buttonHandler?()
    }
}

//MARK: - Configuration
private extension AlertMessageViewController {
    
    func configureView() {
        
        deemBackgroundView.backgroundColor = .black
        deemBackgroundView.alpha = 0.2
        
        alertBackgroundView.backgroundColor = CoinFlowColor.background
        
        titleLabel.text = "안내"
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.textColor = CoinFlowColor.title
        titleLabel.textAlignment = .center
        
        messageLabel.font = .systemFont(ofSize: 14, weight: .regular)
        messageLabel.textColor = CoinFlowColor.title
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        alertStackView.axis = .vertical
        alertStackView.spacing = 16
        alertStackView.distribution = .fill
        alertStackView.alignment = .fill
        
        button.setTitleColor(CoinFlowColor.title, for: .normal)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
    }
    
    func configureHierarchy() {
        view.addSubviews([deemBackgroundView, alertBackgroundView])
        alertBackgroundView.addSubviews([alertStackView, button])
    }
    
    func configureConstraints() {
        
        deemBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        alertBackgroundView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(32)
        }
        
        alertStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(alertStackView.snp.bottom).offset(26)
            make.bottom.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
        }
    }
}
