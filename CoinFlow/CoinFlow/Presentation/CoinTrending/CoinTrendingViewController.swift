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
    private let viewModel = CoinTrendingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureConstraints()
        configureView()
        configureDataSource()
        bind()
    }
    
    private func bind() {
        
        let input = CoinTrendingViewModel.Input(loadView: rx.viewWillAppear,
                                                searchText: searchBar.searchTextField.rx.text.orEmpty,
                                                tapSearchButton: searchBar.rx.searchButtonClicked)
        let output = viewModel.transform(input: input)
        
        output.searchedText
            .compactMap{ $0 }
            .map { text in
                let viewModel = CoinSearchViewModel(searchKeyword: text)
                let coinSearchVC = CoinSearchViewController(viewModel: viewModel)
                return coinSearchVC
            }
            .drive(rx.pushViewController)
            .disposed(by: disposeBag)
            
        output.trendingList
            .drive(rx.updateSnapshot)
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .map{ _ in nil }
            .bind(to: searchBar.searchTextField.rx.text)
            .disposed(by: disposeBag)
    }
}

//MARK: - Configuration
private extension CoinTrendingViewController {
    
    func configureView() {
        view.backgroundColor = CoinFlowColor.background
        navigationItem.leftBarButtonItem = TitleBarButtonItem(title: "가상자산 / 심볼 검색")
        navigationItem.backButtonTitle = ""
        
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
            make.top.equalTo(searchBar.snp.bottom).offset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - CollectionView Layout
private extension CoinTrendingViewController {
    func layout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 40
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProviderHandler, configuration: configuration)
    }
    
    func sectionProviderHandler(sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        guard let section = Section(rawValue: sectionIndex) else {
            fatalError("Could not find section for \(sectionIndex)")
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45), heightDimension: .absolute(height / 3))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .flexible(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: -10, trailing: -10)
        
        section.boundarySupplementaryItems = [headerSupplementaryItem()]
        
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
        
        section.boundarySupplementaryItems = [headerSupplementaryItem()]
        
        return section
    }
    
    func headerSupplementaryItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(40))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: "title-element-kind", alignment: .top)
    }
}

//MARK: - CollectionView DataSource
extension CoinTrendingViewController {
    
    enum Section: Int, CaseIterable {
        case searchKeyword
        case nft
    }
    
    enum Item: Hashable {
        case searchKeyword(CoingeckoTrendingCoin)
        case nft(CoingeckoTrendingNft)
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
        
        let headerSupplementaryProvider = UICollectionView.SupplementaryRegistration(elementKind: "title-element-kind", handler: headerSupplementaryRegistrationHandler)
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerSupplementaryProvider, for: indexPath)
        }
        
        updateSnapshot([], [])
        collectionView.dataSource = dataSource
    }
    
    func trendingSearchKeywordCellRegistrationHandler(cell: TrendingSearchKeywordCollectionViewCell, indexPath: IndexPath, item: CoingeckoTrendingCoin) {
        cell.configure(with: (indexPath.item, item))
    }
    
    func trendingNFTCellRegistrationHandler(cell: TrendingNFTCollectionViewCell, indexPath: IndexPath, item: CoingeckoTrendingNft) {
        cell.configure(with: item)
    }
    
    func headerSupplementaryRegistrationHandler(supplementaryView: HeaderSupplementaryView, string: String, indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Could not find section for \(indexPath.section)")
        }
        
        switch section {
        case .searchKeyword:
            supplementaryView.accessoryLabel.isHidden = false
            supplementaryView.accessoryLabel.text = CoinDateFomatter.trending(Date()).string
            supplementaryView.configure(with: "인기 검색어")
        case .nft:
            supplementaryView.configure(with: "인기 NFT")
        }
    }
    
    func updateSnapshot(_ searchKeywordList: [Item], _ nftList: [Item]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(searchKeywordList, toSection: .searchKeyword)
        snapshot.appendItems(nftList, toSection: .nft)
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
}

//MARK: - Reactive
extension Reactive where Base: CoinTrendingViewController {
    
    var updateSnapshot: Binder<([CoinTrendingViewController.Item], [CoinTrendingViewController.Item])> {
        return Binder(base) { base, list in
            base.updateSnapshot(list.0, list.1)
        }
    }
    
    var pushViewController: Binder<UIViewController> {
        return Binder(base) { base, vc in
            base.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
