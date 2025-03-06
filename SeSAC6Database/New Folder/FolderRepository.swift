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
    func createMemo(data: Folder)
    func fetchAll() -> Results<Folder>
    func deleteItem(data: Folder)
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
    
    func createMemo(data: Folder) {
        let memo = Memo()
        memo.content = "폴더 메모를 작성해주세요"
        memo.regDate = Date()
        memo.editDate = Date()
        do {
            try realm.write {
                data.memo = memo
            }
        } catch {
            print("메모생성 실패!")
        }
    }
    
    func fetchAll() -> Results<Folder> {
        return realm.objects(Folder.self)
    }
    
    func deleteItem(data: Folder) {
        do {
            try realm.write {
                realm.delete(data.detail)
                realm.delete(data)
            }
        } catch {
            print("폴더 삭제 실패!")
        }
    }
}
