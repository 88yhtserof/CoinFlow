//
//  Repository.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/11/25.
//

import Foundation

import RealmSwift

protocol Repository {
    
    associatedtype Table: Object
    
    func add(_ object: Table)
    func delete(_ object: Table)
    func isContained(_ object: Table) -> Bool
    func fetchAll() -> [Table]
}
