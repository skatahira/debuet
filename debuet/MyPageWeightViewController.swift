//
//  MyPageWeightViewController.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/14.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import UIKit
import Charts
import Firebase

// マイページ(体重)画面
class MyPageWeightViewController: UIViewController {

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var standardWeight: UILabel!
    @IBOutlet weak var nowBMI: UILabel!
    @IBOutlet weak var nowWeight: UILabel!
    
    // 表示に使うデータ
    var data:[Double] = [3,1,6,8]
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        addGraph()
        addButton()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.parent?.navigationItem.title = "マイページ"
        getUserInfomation(uid: getUserID())
        getNowRecord(uid: getUserID())
    }
    
    
}

// Firebase関連処理
extension MyPageWeightViewController {
    
    // ユーザID取得処理
    func getUserID() -> String {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("uid is nil")
            return ""
        }
        return uid
    }
    
    // ユーザ情報取得処理
    func getUserInfomation(uid: String) {
        // ユーザ情報取得
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { (document, error) in
            if error != nil {
                // エラー発生した場合
                print("Error")
                return
            } else {
                self.standardWeight.text = String((document!.data()!["standardWeight"] as! Int))
            }
        }
    }
    
    // 現在の記録取得処理
    func getNowRecord(uid: String) {
        // 現在の記録取得
        let docRef = db.collection("users").document(uid).collection("record").order(by: "day", descending: true).limit(to: 1)
        docRef.getDocuments { (docu, error) in
            if error != nil {
                // エラー発生した場合
                print("Error")
                return
            } else {
                for document in docu!.documents {
                    self.nowWeight.text = (document.data()["weight"] as! String)
                    self.nowBMI.text = String(document.data()["BMI"] as! Float)
                }
            }
        }
    }
    
    // 体重記録取得処理
    func getWeight(uid: String) {
        // 現在の記録取得
        let docRef = db.collection("users").document(uid).collection("record").order(by: "day").limit(to: 1)
        docRef.getDocuments { (docu, error) in
            if error != nil {
                // エラー発生した場合
                print("Error")
                return
            } else {
                for document in docu!.documents {
                    self.nowWeight.text = (document.data()["weight"] as! String)
                    self.nowBMI.text = String(document.data()["BMI"] as! Float)
                }
            }
        }
    }
}


// グラフ関連処理
extension MyPageWeightViewController {
    
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
        let dataSet = LineChartDataSet(entries: entries, label: "体重")
        return LineChartData(dataSet: dataSet)
    }
}
