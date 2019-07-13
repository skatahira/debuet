//
//  Date.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/12.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import Foundation

// 日付関連クラス
class DateRelation {
    
    // 本日の年月日をString型で返す(yyyyMMdd形式)
    func todayYMDString() -> String {
        // 現在日時を取得
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        dateFormatter.dateFormat = "yyyyMMdd"
        let calcNow: String = dateFormatter.string(from: nowDate)
        return calcNow
    }
}
