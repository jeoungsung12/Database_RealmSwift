//
//  Folder.swift
//  SeSAC6Database
//
//  Created by 정성윤 on 3/5/25.
//

import Foundation
import RealmSwift

final class Folder: Object {
    @Persisted var id: ObjectId
    @Persisted var name: String
    
    //1:n, to many relationship
    @Persisted var detail: List<JackTable>
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
