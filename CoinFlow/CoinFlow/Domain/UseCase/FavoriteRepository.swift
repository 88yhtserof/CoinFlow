//
//  FavoriteRepository.swift
//  CoinFlow
//
//  Created by 임윤휘 on 3/11/25.
//

import Foundation

import RealmSwift

final class FavoriteRepository: FavoriteRepositoryProtocol {
    
    static let shared = FavoriteRepository()
    private var realm = try! Realm()
    
    private init() {
        print(realm.configuration.fileURL)
    }
    
    func add(_ object: FavoriteTable) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("Error:", error)
        }
    }
    
    func delete(_ object: FavoriteTable) {
        
        do {
            try realm.write {
                let predicate = NSPredicate(format: "id == %@", object.id)
                if let objectToDelete = realm.objects(FavoriteTable.self).filter(predicate).first {
                    realm.delete(objectToDelete)
                }
                
            }
        } catch {
            print("Error:", error)
        }
    }
    
    func isContained(_ object: FavoriteTable) -> Bool {
        realm.object(ofType: FavoriteTable.self, forPrimaryKey: object.id) != nil
    }
    
    func fetchAll() -> [FavoriteTable] {
        realm.objects(FavoriteTable.self).map{ $0 }
    }
}
