//
//  RealmModel.swift
//  SeSAC6Database
//
//  Created by 정성윤 on 3/4/25.
//

import Foundation
import RealmSwift

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

final class Folder: Object {
    @Persisted var name: String
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
