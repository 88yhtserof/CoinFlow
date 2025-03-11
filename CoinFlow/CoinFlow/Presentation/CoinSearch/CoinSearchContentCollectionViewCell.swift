//
//  CoinSearchContentCollectionViewCell.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/10/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class CoinSearchContentCollectionViewCell: UICollectionViewCell, BaseCollectionViewCell {
    
    static let identifier = String(describing: CoinListCollectionViewCell.self)
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.dataSource = nil
        disposeBag = DisposeBag()
        
    }
    
    func configure(with value: [CoingeckoSearchCoin]) {
        Observable.just(value)
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(cellIdentifier: CoinListCollectionViewCell.identifier, cellType: CoinListCollectionViewCell.self)) { item, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - Configuration
private extension CoinSearchContentCollectionViewCell {
    
    func configureView() {
        
        collectionView.backgroundColor = .clear
        collectionView.register(CoinListCollectionViewCell.self, forCellWithReuseIdentifier: CoinListCollectionViewCell.identifier)
    }
    
    func configureHierarchy() {
        contentView.addSubviews([collectionView])
    }
    
    func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(60)
        }
    }
}

//MARK: - CollectionView Layout
private extension CoinSearchContentCollectionViewCell {
    func layout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout { sectionIndexColor, environment in
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
            section.interGroupSpacing = 10
            return section
        }
    }
}
