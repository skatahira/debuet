//
//  todayRecord.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/12.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

// 本日の記録クラス
class TodayRecord {
    // ドキュメントのid
    var id: String!
    // 体重
    var weight: Int!
    // 朝食の量
    var breakfast: Int!
    // 昼食の量
    var lunch: Int!
    // 夕飯の量
    var dinner: Int!
    
    // 初期化時に使うメソッド
    init(id:String, weight: Int,breakfast:Int, lunch:Int, dinner:Int) {
        self.id = id
        self.weight = weight
        self.breakfast = breakfast
        self.lunch = lunch
        self.dinner = dinner
    }
}

