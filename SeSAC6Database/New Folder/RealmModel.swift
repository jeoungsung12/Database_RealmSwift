//
//  RealmModel.swift
//  SeSAC6Database
//
//  Created by 정성윤 on 3/4/25.
//

import Foundation
import RealmSwift
//Realm Table - to many relationship, to one relationship, inverse
//정말 동일하다면 같이 써도 되긴 하지만 -> 서버 변경, 디비 컬럼 변경
// -> Table 내 선언되어 있는 모든 컬럼들이 decodable
// -> Realm 의 특성중 Decdoable을 따르지 않는 타입을 사용하게 되면??
final class JackTable: Object {
    //기본키, 중복X, 비어X, index embed!!
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var money: Int //금액
    @Persisted var category: String // 카테고리명
    
    @Persisted(indexed: true) var name: String //상품명
    @Persisted var isPay: Bool //수입지출여부
    @Persisted var memo: String? //메모
    @Persisted var date: Date //등록일
    @Persisted var like: Bool //좋아요
    
    //폴더로 링킹이 되어있던데? 부모에대한 폴더 확인!(정보확인) 없으면 부모에 대한 건 모름!
    @Persisted(originProperty: "detail")
    var folder: LinkingObjects<Folder>
    
    convenience init(
        money: Int,
        category: String,
        name: String,
        isPay: Bool,
        memo: String? = nil
    ) {
        self.init()
        self.money = money
        self.category = category
        self.name = name
        self.isPay = isPay
        self.memo = memo
        self.date = Date()
        self.like = false
    }
}
