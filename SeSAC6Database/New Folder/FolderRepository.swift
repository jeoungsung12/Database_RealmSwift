//
//  FolderRepository.swift
//  SeSAC6Database
//
//  Created by 정성윤 on 3/5/25.
//

import Foundation
import RealmSwift

protocol FolderRepositoryType {
    func createItem(name: String)
    func fetchAll() -> Results<Folder>
}

final class FolderRepository: FolderRepositoryType {
    
    private let realm = try! Realm()
    
    func createItem(name: String) {
        do {
            try realm.write {
                let folder = Folder(name: name)
                realm.add(folder)
            }
        } catch {
            print("폴더 저장 실패")
        }
    }
    
    func fetchAll() -> Results<Folder> {
        return realm.objects(Folder.self)
    }
}
