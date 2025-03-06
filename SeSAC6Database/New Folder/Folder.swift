//
//  Folder.swift
//  SeSAC6Database
//
//  Created by 정성윤 on 3/5/25.
//

import Foundation
import RealmSwift

//class User: Hashable, Equatable {
//    
//    static func == (lhs: User, rhs: User) -> Bool {
//        lhs.id == rhs.id
//    }
//    
//    let id = UUID()
//    let name: String
//    let age: Int
//    
//    //Hashable
//    func hash(into hasher: inout Hasher) {
//        <#code#>
//    }
//    
//    init(name: String, age: Int) {
//        self.name = name
//        self.age = age
//    }
//}

final class Folder: Object {
    @Persisted var id: ObjectId
    @Persisted var name: String
    @Persisted var favorite: Bool
    @Persisted var nameDescription: String
    //1:n, to many relationship
    @Persisted var detail: List<JackTable>
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
