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
    
    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        let tv = UITextView(frame: CGRect(x: 0, y: 0, width: self.frame.width-30, height: self.frame.height-30))
        self.addSubview(tv)
        
        tv.center = self.center
        tv.text = text
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
