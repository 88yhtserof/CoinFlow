//
//  CoinTrendingViewController.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/6/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class CoinTrendingViewController: UIViewController {
    
    private let searchBar = SearchBar()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureConstraints()
        configureView()
        bind()
    }
    
    private func bind() {
        
        Observable.just(["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14"])
            .bind(to: collectionView.rx.items(cellIdentifier: TrendingSearchKeywordCollectionViewCell.identifier,
                                              cellType: TrendingSearchKeywordCollectionViewCell.self)) { item, element, cell in
                cell.configure(with: element)
            }.disposed(by: disposeBag)
    }
}

//MARK: - Configuration
private extension CoinTrendingViewController {
    
    func configureView() {
        view.backgroundColor = CoinFlowColor.background
        navigationItem.leftBarButtonItem = TitleBarButtonItem(title: "가상자산 / 심볼 검색")
        
        collectionView.register(TrendingSearchKeywordCollectionViewCell.self, forCellWithReuseIdentifier: TrendingSearchKeywordCollectionViewCell.identifier)
        collectionView.isScrollEnabled = false
    }
    
    func configureHierarchy() {
        view.addSubviews([searchBar, collectionView])
    }
    
    func configureConstraints() {
        
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - CollectionView Layout
private extension CoinTrendingViewController {
    func layout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 10
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProviderHandler, configuration: configuration)
    }
    
    func sectionProviderHandler(sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        guard let section = Section(rawValue: sectionIndex) else {
            fatalError("Could not find section")
        }
        
        switch section {
        case .searchKeyword:
            return sectionForSearchKeyword()
        }
    }
    
    func sectionForSearchKeyword() -> NSCollectionLayoutSection {
        let height = view.frame.height
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0 / 7.0))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45), heightDimension: .absolute(height / 4.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .flexible(4)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: -10, trailing: -10)
        
        return section
    }
    
    func sectionForNFT() {
        
    }
}

//MARK: - CollectionView DataSource
private extension CoinTrendingViewController {
    
    enum Section: Int {
        case searchKeyword
    }
}
