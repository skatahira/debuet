//
//  MyPageFoodViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/19.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import XLPagerTabStrip

// マイページ(食事)画面
class MyPageFoodViewController: UIViewController, IndicatorInfoProvider {

    // 上タブのタイトル
    var itemInfo: IndicatorInfo = "食事"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // 上タブ管理
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}
