//
//  CoinSearchViewController.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/9/25.
//

import UIKit

import RxSwift
import RxCocoa

final class CoinSearchViewController: UIViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let searchTextField = UITextField()
    
    private var dataSource: DataSource!
    
    private var latestScrollOffset: Double = 0.0
    private var isScrollingUp: Bool = true
    private var currentPage: Int = 0
    
    private let viewModel: CoinSearchViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: CoinSearchViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureConstraints()
        configureView()
        configrueDataSource()
        bind()
    }
    
    private func bind() {
        
        let input = CoinSearchViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.itemTuple
            .drive(rx.updateSnapshot)
            .disposed(by: disposeBag)
        
        output.searchedText
            .drive(searchTextField.rx.text)
            .disposed(by: disposeBag)
    }
}

//MARK: - Configuration
private extension CoinSearchViewController {
    
    func configureView() {
        view.backgroundColor = CoinFlowColor.background
        navigationItem.backButtonTitle = ""
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchTextField)
        
        searchTextField.placeholder = "검색어를 입력하세요"
        searchTextField.font = .systemFont(ofSize: 12, weight: .regular)
        searchTextField.textAlignment = .left
        
        collectionView.bounces = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "indicator cell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "content cell")
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
private extension CoinSearchViewController {
    func layout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Could not find section for \(sectionIndex)")
            }
            
            switch section {
            case .title:
                return self?.sectionForTitle()
            case .indicator:
                return self?.sectionForIndicator()
            case .content:
                return self?.sectionForContent()
            }
        }
    }
    
    func sectionForTitle() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 3.0), heightDimension: .fractionalHeight(1.0))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func sectionForIndicator() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 3.0), heightDimension: .fractionalHeight(1.0))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(2.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func sectionForContent() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = contentSectionVisibleItemsInvalidationHandler
        return section
    }
    
    func contentSectionVisibleItemsInvalidationHandler(visibleItems: [any NSCollectionLayoutVisibleItem], scrollOffset: CGPoint, layoutEnvironment: NSCollectionLayoutEnvironment) {
        guard let last = visibleItems.last?.indexPath.item else { return }
        
        if last != currentPage {
            currentPage = last
        }
    }
}

//MARK: - CollectionView DataSource
extension CoinSearchViewController {
    
    enum Section: Int, CaseIterable {
        case title
        case indicator
        case content
    }
    
    enum Item: Hashable {
        case title(String)
        case indicator(Int)
        case content(Content)
        
        enum Content: Hashable {
            case coins([CoingeckoSearchCoin])
            case nfts([String])
            case exchanges([String])
        }
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    func configrueDataSource() {
        
        let titleCellRegiatration = UICollectionView.CellRegistration(handler: titleCellRegistration)
        let indicatorCellRegiatration = UICollectionView.CellRegistration(handler: indicatorCellRegistration)
        let contentCellRegiatration = UICollectionView.CellRegistration(handler: contentCellRegistration)
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .title(let value):
                return collectionView.dequeueConfiguredReusableCell(using: titleCellRegiatration, for: indexPath, item: value)
            case .indicator(let value):
                return collectionView.dequeueConfiguredReusableCell(using: indicatorCellRegiatration, for: indexPath, item: value)
            case .content(let value):
                return collectionView.dequeueConfiguredReusableCell(using: contentCellRegiatration, for: indexPath, item: value)
            }
        })
        
        updateSnapshot([], [], [])
        collectionView.dataSource = dataSource
    }
    
    func titleCellRegistration(cell: TitleCollectionViewCell, indexPath: IndexPath, item: String) {
        cell.configure(with: item)
        if indexPath.item == 0 {
            cell.titleLabel.textColor = CoinFlowColor.title
        }
    }
    
    func indicatorCellRegistration(cell: UICollectionViewCell, indexPath: IndexPath, item: Int) {
        if indexPath.item == 0 {
            cell.contentView.backgroundColor = CoinFlowColor.title
        } else {
            cell.contentView.backgroundColor = CoinFlowColor.subtitle
        }
    }
    
    func contentCellRegistration(cell: CoinSearchContentCollectionViewCell, indexPath: IndexPath, item: Item.Content) {
        
        switch item {
        case .coins(let list):
            cell.configure(with: list)
        case .nfts:
            cell.contentView.backgroundColor = CoinFlowColor.subtitle
        case .exchanges:
            cell.contentView.backgroundColor = CoinFlowColor.subBackground
        }
    }
    
    func updateSnapshot(_ titleList: [Item], _ indicatorList: [Item], _ contentList: [Item]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(titleList, toSection: .title)
        snapshot.appendItems(indicatorList, toSection: .indicator)
        snapshot.appendItems(contentList, toSection: .content)
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
}

//MARK: - CollectionView Delegate
extension CoinSearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.section == 2 else { return }
        
        let titleAfterIndexPath = IndexPath(item: currentPage, section: 0)
        let titleAfterCell = collectionView.cellForItem(at: titleAfterIndexPath) as? TitleCollectionViewCell
        titleAfterCell?.titleLabel.textColor = CoinFlowColor.title
        
        let titleBeforeIndexPath = IndexPath(item: indexPath.item, section: 0)
        let titleBeforeCell = collectionView.cellForItem(at: titleBeforeIndexPath) as? TitleCollectionViewCell
        titleBeforeCell?.titleLabel.textColor = CoinFlowColor.subtitle
        
        let indicatorAfterIndexPath = IndexPath(item: currentPage, section: 1)
        let indicatorAfterCell = collectionView.cellForItem(at: indicatorAfterIndexPath)
        indicatorAfterCell?.contentView.backgroundColor = CoinFlowColor.title
        
        let indicatorBeforeIndexPath = IndexPath(item: indexPath.item, section: 1)
        let indicatorBeforeCell = collectionView.cellForItem(at: indicatorBeforeIndexPath)
        indicatorBeforeCell?.contentView.backgroundColor = CoinFlowColor.subtitle
    }
}

//MARK: - Reactive
extension Reactive where Base: CoinSearchViewController {
    
    var updateSnapshot: Binder<([CoinSearchViewController.Item], [CoinSearchViewController.Item], [CoinSearchViewController.Item])> {
        return Binder(base) { base, list in
            base.updateSnapshot(list.0, list.1, list.2)
        }
    }
}
