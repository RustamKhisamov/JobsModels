//
//  DataBase.swift
//  GitJobs
//
//  Created by Rustam on 03.04.2021.
//

import Foundation
import RealmSwift

final class DataBase<T: Object> {
    private let realm = try? Realm()
    
    public init() {}
    
    
    public func list() -> [T]? {
        guard let result = realm?.objects(T.self) else {
            return []
        }
        return Array(result)
    }
    
    public func store(_ objects: [T]) {
        write { self.realm?.add(objects, update: .all) }
    }
    
    public func write(_ closure: () -> Void) {
        try! realm?.write { closure() }
    }
    
    public func cached(_ id: String) -> T? {
        realm?.object(ofType: T.self, forPrimaryKey: id)
    }
    
    public func delete() {
        write { realm?.deleteAll() }
    }
}
