//
//  FavoriteRepositoryProtocol.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/11/25.
//

import Foundation

protocol FavoriteRepositoryProtocol: Repository where Table == FavoriteTable {
    
    func add(_ object: Table)
    func delete(_ object: Table)
    func isContained(_ object: Table) -> Bool
    func fetchAll() -> [Table]
}
