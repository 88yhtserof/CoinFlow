//
//  CoinExchangeViewController.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/6/25.
//

import UIKit

import RxSwift
import RxCocoa

final class CoinExchangeViewController: UIViewController {
    
    private let exchangeBar = ExchangeBar()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private let viewModel = CoinExchangeViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureConstraints()
        configureView()
        bind()
    }
    
    private func bind() {
        
        let input = CoinExchangeViewModel.Input(changeSort: exchangeBar.rx.sort,
                                                loadView: rx.viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.sortedMarketList
            .drive(collectionView.rx.items(cellIdentifier: CoinExchangeCollectionViewCell.identifier,
                                           cellType: CoinExchangeCollectionViewCell.self)) { item, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .map({ value in
                let (message, handler) = value
                let alertMessageVC = AlertMessageViewController()
                alertMessageVC.message = message
                alertMessageVC.buttonTitle = "다시 시도하기"
                alertMessageVC.buttonHandler = handler
                alertMessageVC.modalPresentationStyle = .overCurrentContext
                alertMessageVC.modalTransitionStyle = .crossDissolve
                return alertMessageVC
            })
            .drive(rx.present)
            .disposed(by: disposeBag)
    }
}

//MARK: - Configuration
private extension CoinExchangeViewController {
    
    func configureView() {
        view.backgroundColor = CoinFlowColor.background
        navigationItem.leftBarButtonItem = TitleBarButtonItem(title: "거래소")
        navigationItem.backButtonTitle = ""
        
        collectionView.register(CoinExchangeCollectionViewCell.self, forCellWithReuseIdentifier: CoinExchangeCollectionViewCell.identifier)
        collectionView.allowsSelection = false
    }
    
    func configureHierarchy() {
        view.addSubviews([exchangeBar, collectionView])
    }
    
    func configureConstraints() {
        
        exchangeBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(exchangeBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - CollectionView Layout
private extension CoinExchangeViewController {
    func layout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout { sectionIndexColor, environment in
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
            section.interGroupSpacing = 10
            return section
        }
    }
}

//MARK: - Reactive
extension Reactive where Base: CoinExchangeViewController {
    
    var present: Binder<UIViewController> {
        return Binder(base) { base, vc in
            base.present(vc, animated: true)
        }
    }
}
