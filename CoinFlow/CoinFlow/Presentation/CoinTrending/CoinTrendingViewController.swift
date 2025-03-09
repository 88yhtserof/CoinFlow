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
    
    private var dataSource: DataSource!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureConstraints()
        configureView()
        configureDataSource()
        bind()
    }
    
    private func bind() {
        
//        Observable.just(["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14"])
//            .bind(to: collectionView.rx.items(cellIdentifier: TrendingSearchKeywordCollectionViewCell.identifier,
//                                              cellType: TrendingSearchKeywordCollectionViewCell.self)) { item, element, cell in
//                cell.configure(with: element)
//            }.disposed(by: disposeBag)
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
        case .nft:
            return sectionForNFT()
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
    
    func sectionForNFT() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 4.0), heightDimension: .absolute(110))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        return section
    }
}

//MARK: - CollectionView DataSource
private extension CoinTrendingViewController {
    
    enum Section: Int, CaseIterable {
        case searchKeyword
        case nft
    }
    
    enum Item: Hashable {
        case searchKeyword(Int)
        case nft(Int)
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    func configureDataSource() {
        let trendingSearchKeywordCellRegistration = UICollectionView.CellRegistration(handler: trendingSearchKeywordCellRegistrationHandler)
        let trendingNFTCellRegistration = UICollectionView.CellRegistration(handler: trendingNFTCellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView,
                                cellProvider: { collectionView, indexPath, item in
            switch item {
            case .searchKeyword(let value):
                return collectionView.dequeueConfiguredReusableCell(using: trendingSearchKeywordCellRegistration, for: indexPath, item: value)
            case .nft(let value):
                return collectionView.dequeueConfiguredReusableCell(using: trendingNFTCellRegistration, for: indexPath, item: value)
            }
        })
        
        createSnapshot([])
        collectionView.dataSource = dataSource
    }
    
    func trendingSearchKeywordCellRegistrationHandler(cell: TrendingSearchKeywordCollectionViewCell, indexPath: IndexPath, item: Int) {
        
    }
    
    func trendingNFTCellRegistrationHandler(cell: TrendingNFTCollectionViewCell, indexPath: IndexPath, item: Int) {
        
    }
    
    func createSnapshot(_ items: [Item]) {
        let list1 = Array(1...14).map{ Item.searchKeyword($0) }
        let list2 = Array(1...7).map{ Item.nft($0) }
        
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list1, toSection: .searchKeyword)
        snapshot.appendItems(list2, toSection: .nft)
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
}
