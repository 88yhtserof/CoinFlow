//
//  AppDelegate.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/6/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkMonitorManager.shared.startMonitoring()
        
        configureNavigationBarAppearance()
        return true
    }
}

//MARK: - Appearance
extension  AppDelegate {
    
    func configureNavigationBarAppearance() {
        
        UINavigationBar.appearance().tintColor = CoinFlowColor.title
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "arrow.left")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
    }
}

