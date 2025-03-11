//
//  CoinDetailViewController.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/11/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class CoinDetailViewController: UIViewController {

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let favoriteButton = FavoriteButton()
    private let iconTitleView = IconTitleView()
    
    private var dataSource: DataSource!
    
    private let viewModel: CoinDetailViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: CoinDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureConstraints()
        configureView()
        configureDataSource()
        bind()
        
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteButtonDidSave), name: NSNotification.Name("FavoriteButtonDidSave"), object: nil)
    }
    
    @objc func favoriteButtonDidSave(_ notification: Notification) {
        guard let message = notification.userInfo?["message"] as? String else {
            print("Failed to get saving message")
            return
        }
        self.view.makeToast(message, duration: 2.0, position: .bottom)
    }
    
    @objc func didMoreButtonTapped() {
        self.view.makeToast("준비 중입니다.", duration: 2.0, position: .bottom)
    }
    
    private func bind() {
        
        let input = CoinDetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.coinsMarket
            .compactMap{ $0 }
            .drive(with: self) { owner, coinsMaket in
                owner.iconTitleView.rx.title.onNext(coinsMaket.symbol)
                owner.iconTitleView.setImage(string: coinsMaket.image)
                owner.favoriteButton.bind(viewModel: FavoriteButtonViewModel(id: coinsMaket.id))
                owner.rx.updateSnapshot.onNext(([Item.chart(coinsMaket)], [Item.coinInfo(coinsMaket)], [Item.coinIndicator(coinsMaket)]))
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - Configuration
private extension CoinDetailViewController {
    
    func configureView() {
        view.backgroundColor = CoinFlowColor.background
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        navigationItem.titleView = iconTitleView
    }
    
    func configureHierarchy() {
        view.addSubviews([collectionView])
    }
    
    func configureConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - CollectionView Layout
private extension CoinDetailViewController {
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
        case .chart:
            return sectionForChart()
        case .coinInfo:
            return sectionForCoinInfo()
        case .coinIndicator:
            return sectionForCoinIndicator()
        }
    }
    
    func sectionForChart() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        
        section.boundarySupplementaryItems = [headerSupplementaryItem()]
        
        return section
    }
    
    func sectionForCoinInfo() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(140))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        
        section.boundarySupplementaryItems = [headerSupplementaryItem()]
        
        return section
    }
    
    func sectionForCoinIndicator() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(180))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        
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
extension CoinDetailViewController {
    
    enum Section: Int, CaseIterable {
        case chart
        case coinInfo
        case coinIndicator
        
    }
    
    enum Item: Hashable {
        case chart(CoingeckoCoinsMarket) //CoingeckoCoinMarketResponse
        case coinInfo(CoingeckoCoinsMarket) //CoingeckoCoinMarketResponse
        case coinIndicator(CoingeckoCoinsMarket) //CoingeckoCoinMarketResponse
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    func configureDataSource() {
        let chartCellRegistration = UICollectionView.CellRegistration(handler: chartCellRegistrationHandler)
        let coinInfoCellRegistration = UICollectionView.CellRegistration(handler: coinInfoCellRegistrationHandler)
        let coinIndicatorCellRegistration = UICollectionView.CellRegistration(handler: coinIndicatorCellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView,
                                cellProvider: { collectionView, indexPath, item in
            switch item {
            case .chart(let value):
                return collectionView.dequeueConfiguredReusableCell(using: chartCellRegistration, for: indexPath, item: value)
            case .coinInfo(let value):
                return collectionView.dequeueConfiguredReusableCell(using: coinInfoCellRegistration, for: indexPath, item: value)
            case .coinIndicator(let value):
                return collectionView.dequeueConfiguredReusableCell(using: coinIndicatorCellRegistration, for: indexPath, item: value)
            }
        })
        
        let headerSupplementaryProvider = UICollectionView.SupplementaryRegistration(elementKind: "title-element-kind", handler: headerSupplementaryRegistrationHandler)
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerSupplementaryProvider, for: indexPath)
        }
        
        updateSnapshot([], [], [])
        collectionView.dataSource = dataSource
    }
    
    func chartCellRegistrationHandler(cell: ChartCollectionViewCell, indexPath: IndexPath, item: CoingeckoCoinsMarket) {
        cell.configure(with: item)
    }
    
    func coinInfoCellRegistrationHandler(cell: CoinInfoCollectionViewCell, indexPath: IndexPath, item: CoingeckoCoinsMarket) {
        cell.configure(with: item)
    }
    
    func coinIndicatorCellRegistrationHandler(cell: CoinIndicatorCollectionViewCell, indexPath: IndexPath, item: CoingeckoCoinsMarket) {
        cell.configure(with: item)
    }
    
    func headerSupplementaryRegistrationHandler(supplementaryView: HeaderSupplementaryView, string: String, indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Could not find section for \(indexPath.section)")
        }
        
        switch section {
        case .chart:
            break
        case .coinInfo:
            let configuration = UIButton.Configuration.accessory(title: "더보기", image: "chevron.right")
            supplementaryView.accessoryButtonConfiguration = configuration
            supplementaryView.accessoryButton.addTarget(self, action: #selector(didMoreButtonTapped), for: .touchUpInside)
            supplementaryView.configure(with: "종목정보")
        case .coinIndicator:
            let configuration = UIButton.Configuration.accessory(title: "더보기", image: "chevron.right")
            supplementaryView.accessoryButtonConfiguration = configuration
            supplementaryView.accessoryButton.addTarget(self, action: #selector(didMoreButtonTapped), for: .touchUpInside)
            supplementaryView.configure(with: "투자지표")
        }
    }
    
    func updateSnapshot(_ chart: [Item], _ coinInfo: [Item],  _ coinIndicator: [Item]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(chart, toSection: .chart)
        snapshot.appendItems(coinInfo, toSection: .coinInfo)
        snapshot.appendItems(coinIndicator, toSection: .coinIndicator)
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
}

//MARK: - Reactive
extension Reactive where Base: CoinDetailViewController {
    
    var updateSnapshot: Binder<([CoinDetailViewController.Item], [CoinDetailViewController.Item], [CoinDetailViewController.Item])> {
        return Binder(base) { base, list in
            base.updateSnapshot(list.0, list.1, list.2)
        }
    }
}
