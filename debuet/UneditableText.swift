//
//  UneditableText.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/21.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit

// 編集不可テキスト関連クラス
class UneditableText: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tv = UITextView(frame: CGRect(x: 0, y: 0, width: self.frame.width-30, height: self.frame.height-30))
        self.addSubview(tv)
        
        tv.center = self.center
        
        // 呼び出し元を取得
        let symbols = Thread.callStackSymbols
        // 呼び出し元が記載されている箇所を取り出す
        let tOSFlg: String = symbols.count >= 2 ? symbols[3] : ""
        
        // 文字列にTOSが含まれていた場合
        if tOSFlg.contains("TOS") {
            // 利用規約画面から遷移
            let tos = TOSViewController()
            // テキストを格納
            tv.text = tos.text
        } else {
            // 個人情報保護方針画面から遷移
            let pri = PrivacyPolicyViewController()
            tv.text = pri.text
        }
        
        tv.textColor = UIColor.darkText
        tv.font = UIFont.systemFont(ofSize: 13.0)
        
        // リンクをクリック可能にする (PhoneNumber, Link, Address, CalenderEvent, None, All)
        tv.dataDetectorTypes = UIDataDetectorTypes.link
        
        // 文字を編集不可とする
        tv.isEditable = false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
