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
    
    private var dataSource: DataSource!
    
    private var latestScrollOffset: Double = 0.0
    private var isScrollingUp: Bool = true
    private var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureConstraints()
        configureView()
        configrueDataSource()
    }
}

//MARK: - Configuration
private extension CoinSearchViewController {
    
    func configureView() {
        view.backgroundColor = CoinFlowColor.background
        
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
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 3.0), heightDimension: .absolute(44.0))
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        
//        let section = NSCollectionLayoutSection(group: horizontalGroup)
        
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
        case content(String)
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
        
        updateSnapshot([])
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
    
    func contentCellRegistration(cell: UICollectionViewCell, indexPath: IndexPath, item: String) {
    }
    
    func updateSnapshot(_ items: [Item]) {
        let titleList = ["1", "2", "3"].map{ Item.title($0) }
        let indicatorList = [1, 2, 3].map{ Item.indicator($0) }
        let list = ["1", "2", "3"].map{ Item.content($0) }
        
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(titleList, toSection: .title)
        snapshot.appendItems(indicatorList, toSection: .indicator)
        snapshot.appendItems(list, toSection: .content)
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
    
    var updateSnapshot: Binder<[CoinSearchViewController.Item]> {
        return Binder(base) { base, list in
            base.updateSnapshot(list)
        }
    }
}
