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
        //バーの色
        settings.style.buttonBarBackgroundColor = UIColor.lightGray
        //ボタンの色
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        //セルの文字色
        settings.style.buttonBarItemTitleColor = UIColor.black
        //セレクトバーの色
        settings.style.selectedBarBackgroundColor = UIColor.hex(string: "#F9759D", alpha: 1)
        // ボタンの間隔
        settings.style.buttonBarMinimumLineSpacing = CGFloat(1)

        super.viewDidLoad()
        
        

    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //管理されるViewControllerを返す処理
        let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Weight")
        let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Meal")
        let childViewControllers:[UIViewController] = [firstVC, secondVC]
        return childViewControllers
    }

}
