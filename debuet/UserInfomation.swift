//
//  UserInfomation.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/05.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import Foundation
import UIKit

// ユーザインフォメーションクラス
class UserInfomation {
 
    // ユーザ名
    var userName: String = ""
    // ユーザ画像
    var userPicture: UIImage? = nil
    // 誕生日
    var birth: Date? = nil
    // 性別
    var sex: String = ""
    // 身体活動レベル
    var physicalActiveLevel: String = ""
    // 身長
    var height: String = "0.0"
    // 目標
    var goalText: String = ""
    // 必要食事量
    var amountOfFood: Float = 0.0
    // BMI
    var bmi: Float = 0.0
    // 年齢
    var age: Int = 0
    // 適正標準体重
    var standardWeight:Float  = 0.0
    // 基礎代謝量
    var basalMetabolicRate:Int = 0
    // 必要推定エネルギー量
    var requiredEnergy = 0
    
    func setUserName(userName: String) -> Void {
        self.userName = userName
    }
    
    func setUserPicture(userPicture: UIImage) -> Void {
        self.userPicture = userPicture
    }
    
    func setBirth(birth: Date) -> Void {
        self.birth = birth
    }
    
    func setSex(sex: String) -> Void {
        self.sex = sex
    }
    
    func setPhysicalActiveLevel(physicalActiveLevel: String) -> Void {
        self.physicalActiveLevel = physicalActiveLevel
    }
    
    func setHeight(height: String) -> Void {
        self.height = height
    }
    
    func setGoalText(goalText: String) -> Void {
        self.goalText = goalText
    }
    
    func setAmountOfFood(amountOfFood: Float) -> Void {
        self.amountOfFood = amountOfFood
    }
    
    func setBmi(bmi: Float) -> Void {
        self.bmi = bmi
    }
    
    func setAge(age: Int) -> Void {
        self.age = age
    }
    
    func setStandardWeight(standardWeight: Float) -> Void {
        self.standardWeight = standardWeight
    }
    
    func setBasalMetabolicRate(basalMetabolicRate: Int) -> Void {
        self.basalMetabolicRate = basalMetabolicRate
    }
    
    func setRequiredEnergy(requiredEnergy: Int) -> Void {
        self.requiredEnergy = requiredEnergy
    }
}
