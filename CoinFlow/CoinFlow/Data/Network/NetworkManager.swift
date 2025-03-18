//
//  NetworkManager.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/8/25.
//

import Foundation

import Alamofire
import RxSwift
import RxCocoa

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<T: Decodable>(api: BaseNetworkAPI) -> Single<T> {
        
        return Single<T>.create { observer in
            guard let url = api.url else {
                observer(.failure(NSError())) // 이후 에러 처리 필요
                return Disposables.create()
            }
            
            AF.request(url,
                       method: api.method,
                       parameters: api.parameters,
                       headers: api.headers)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    print("Success")
                    observer(.success(value))
                case .failure(let afError):
                    let error = api.error(response)
                    print("Error: \(error.errorLog)", afError, separator: "\n")
                    observer(.failure(error))
                }
            }
            return Disposables.create {
                print("NetworkManager request dispose")
            }
        }
    }
}
