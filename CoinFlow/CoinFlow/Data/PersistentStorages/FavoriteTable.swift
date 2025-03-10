//
//  FavoriteTable.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/11/25.
//

import Foundation

import RealmSwift

class FavoriteTable: Object {
    
    @Persisted(primaryKey: true) var id: String
    
    convenience init(id: String) {
        self.init()
        self.id = id
    }
}
