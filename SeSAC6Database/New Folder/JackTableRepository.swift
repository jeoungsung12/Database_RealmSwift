//
//  JackTableRepository.swift
//  SeSAC6Database
//
//  Created by 정성윤 on 3/5/25.
//

import Foundation
import RealmSwift

protocol JackTableRepositoryType {
    func getFileURL()
    func fetchAll() -> Results<JackTable>
    func deleteItem(data: JackTable)
    func createItem()
    func updateItemMoney(data: JackTable)
    func createItemInFolder(folder: Folder, data: JackTable)
}

final class JackTableRepository: JackTableRepositoryType {
    private let realm = try! Realm() //default.realm
    
    func getFileURL() {
        print(realm.configuration.fileURL)
    }
    
    func createItem() { //Folder 테이블과 상관없이 JackTable에 레코드를 바로 추가함.
        do {
            try realm.write {
                let data = JackTable(
                    money: Int.random(in: 100...1000) * 100,
                    category: ["생활비", "카페", "식비"].randomElement()!,
                    name: ["린스", "커피", "과자", "칼국수"].randomElement()!,
                    isPay: false,
                    memo: nil
                )
                realm.add(data)
                print("램 저장완료")
            }
        } catch {
            print("램에 저장이 실패한 경우")
        }
    }
    
    func createItemInFolder(folder: Folder, data: JackTable) { //Folder 테이블과 상관없이 Folder에 레코드를 바로 추가함.
        do {
            try realm.write {
//                let folder = realm.objects(Folder.self)
//                    .where {
//                        $0.name == "개인"
//                    }.first!
                
                let data = JackTable(
                    money: Int.random(in: 100...1000) * 100,
                    category: ["생활비", "카페", "식비"].randomElement()!,
                    name: ["린스", "커피", "과자", "칼국수"].randomElement()!,
                    isPay: false,
                    memo: nil
                )
                folder.detail.append(data)
//                realm.add(folder, update: .modified)
                print("램 저장완료")
            }
        } catch {
            print("램에 저장이 실패한 경우")
        }
    }
    
    func fetchAll() -> Results<JackTable> {
        let data = realm.objects(JackTable.self)
//            .where { $0.name.contains("sesac", options: .caseInsensitive) }
            .sorted(byKeyPath: "money", ascending: false)
        
        return data
    }
    
    func deleteItem(data: JackTable) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print("램 데이터 삭제 실패")
        }
    }
    
    func updateItemMoney(data: JackTable) {
        do {
            try realm.write {
                //수정
                realm.create(JackTable.self, value: [
                    "id": data.id,
                    "money": 100000000
                ], update: .modified)
                
            }
        } catch {
            print("램 데이터 수정 실패")
        }
    }
    
}
