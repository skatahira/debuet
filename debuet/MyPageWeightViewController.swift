//
//  MyPageWeightViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/14.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Charts

// マイページ(体重)画面
class MyPageWeightViewController: UIViewController {

    @IBOutlet weak var chartView: LineChartView!
    
    // 表示に使うデータ
    var data:[Double] = [3,1,6,8]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addGraph()
        addButton()
        
    }
    
    // グラフを画面に追加する
    func addGraph() {
        // 位置とサイズ
        let width: CGFloat = view.bounds.width
        let height: CGFloat = view.bounds.height / 4 * 3
        let rect = CGRect(x:0, y: 30, width: width, height: height)
        
        // グラフ表示部のインスタンス化
//        chartView = LineChartView(frame: rect)
        // 表示データの設定
        chartView?.data = getDataSet()
        // 画面に追加
        view.addSubview(chartView!)
    }
    
    func addButton() {
        let width: CGFloat = 200
        let height: CGFloat = 50
        let x: CGFloat = view.bounds.width / 2 - width / 2
        let y: CGFloat = view.bounds.height / 8 * 7 - height / 2
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.frame = rect
        button.addTarget(
            self,
            action: #selector(didClickBtn(_:)),
            for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func didClickBtn(_ sender: UIButton) {
        data.append(Double.random(in: 1.0...20.0))
        chartView!.data = getDataSet()
    }
    
    // 表示用のデータの整形
    func getDataSet() -> LineChartData {
        // データにある情報をグラフ用のデータに変換
        let entries = data.enumerated().map { ChartDataEntry(x: Double($0.offset), y: $0.element) }
        // 折れ線グラフのデータセット
        let dataSet = LineChartDataSet(entries: entries, label: "タイトル")
        return LineChartData(dataSet: dataSet)
    }
    
}
