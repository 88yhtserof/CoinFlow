//
//  NetworkMonitor.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/18/25.
//

import Foundation
import Network

import RxSwift
import RxCocoa

protocol NetworkMonitor {
    var isConnected: Observable<Bool> { get }
    func startMonitoring()
    func stopMonitoring()
}

final class NetworkMonitorManager: NetworkMonitor {
    
    static let shared = NetworkMonitorManager()
    private let monitor = NWPathMonitor()
    private let subject = BehaviorSubject<Bool>(value: false)
    
    var isConnected: Observable<Bool> {
        return subject.asObservable()
    }
    
    private init() {
        monitor.pathUpdateHandler = { path in
            switch path.status {
            case .satisfied:
                print(".satisfied Connect")
                self.subject.onNext(true)
            default:
                print("network disconnected")
                self.subject.onNext(false)
            }
        }
    }
    
    func startMonitoring() {
        print("NetworkMonitor Start")
        
        monitor.start(queue: DispatchQueue.global())
    }
    
    func stopMonitoring() {
        print("NetworkMonitor Stop")
        monitor.cancel()
    }
}
