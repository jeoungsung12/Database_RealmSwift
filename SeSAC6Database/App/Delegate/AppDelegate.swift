//
//  AppDelegate.swift
//  SeSAC6Database
//
//  Created by Jack on 3/4/25.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //마이그래이션
        migration()
        
        let realm = try! Realm()
        //현재 사용자가 쓰고 있는 DB Schema Version check
        do {
            let verson = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("램 스키마 버전 \(verson)")
        } catch {
            //스키마 가져오기 실패!
            print("Schema Failed")
        }
        
        return true
    }
    
    private func migration() {
        let config = Realm.Configuration(schemaVersion: 6) { migration, oldSchemaVersion in
            //0 -> 1: Folder에 like 추가
            //단순히 테이블, 컬럼 추가 삭제에는 코드 필요 X
            if oldSchemaVersion < 1 { }
            //1 -> 2: Folder like 삭제
            if oldSchemaVersion < 2 { }
            //2 -> 3: Folder like 추가
            if oldSchemaVersion < 3 {
                migration.enumerateObjects(ofType: Folder.className()) { oldObject, newObject in
                    guard let newObject = newObject else { return }
                    newObject["like"] = true
                }
            }
            //3 -> 4: Folder like를 favorite로 수정(네이밍만 수정)
            if oldSchemaVersion < 4 {
                migration.renameProperty(onType: Folder.className(), from: "like", to: "favorite")
            }
            //4 -> 5: Folder에 nameDescription 추가
            //Folder name 필드 활용
            if oldSchemaVersion < 5 {
                migration.enumerateObjects(ofType: Folder.className()) { oldObject, newObject in
                    guard let oldObject = oldObject else { return }
                    guard let newObject = newObject else { return }
                    newObject["nameDescription"] = oldObject["name"] ?? "" + "폴더에 대해서 설명해주세요."
                }
            }
            //5 -> 6: Memo EmbededObject 생성
            if oldSchemaVersion < 6 { }
            
        }
        Realm.Configuration.defaultConfiguration = config
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


}

