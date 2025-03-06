//
//  TabBarController.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/6/25.
//

import UIKit

final class TabBarController: UITabBarController {
    
    enum Item: String, CaseIterable {
        case exchange = "거래소"
        case coinInfo = "코인정보"
        case portfolio = "포트폴리오"
        
        var title: String {
            return rawValue
        }
        
        var image: String {
            switch self {
            case .exchange:
                return "chart.line.uptrend.xyaxis"
            case .coinInfo:
                return "chart.bar.fill"
            case .portfolio:
                return "star"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
        configureTabBarAppearance()
    }
}

//MARK: - Configuration
private extension TabBarController {
    func configureViewControllers() {
        let viewControllers = [
            UINavigationController(rootViewController: CoinExchangeViewController()),
            UINavigationController(rootViewController: CoinTrendingViewController()),
            UINavigationController(rootViewController: PortfolioViewController())
        ]
        
        zip(viewControllers, Item.allCases)
            .forEach{ viewController, item in
                viewController.tabBarItem.title = item.title
                viewController.tabBarItem.image = UIImage(systemName: item.image)
                viewController.tabBarItem.selectedImage = UIImage(systemName: item.image)
            }
        
        setViewControllers(viewControllers, animated: false)
    }
    
    func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        appearance.stackedLayoutAppearance.selected.iconColor = CoinFlowColor.title
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: CoinFlowColor.title]
        
        appearance.stackedLayoutAppearance.normal.iconColor = CoinFlowColor.subtitle
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: CoinFlowColor.subtitle]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
