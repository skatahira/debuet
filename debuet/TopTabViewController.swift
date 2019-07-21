//
//  TopTabViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/20.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import XLPagerTabStrip

// 上タブ管理クラス
class TopTabViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //管理されるViewControllerを返す処理
        let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "First")
        let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Second")
        let childViewControllers:[UIViewController] = [firstVC, secondVC]
        return childViewControllers
    }

}
