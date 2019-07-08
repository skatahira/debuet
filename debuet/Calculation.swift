//
//  Calculation.swift
//  debuet
//
//  Created by 片平駿介 on 2019/07/07.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import Foundation

// 計算処理クラス
class Calculation {
    
    // 標準体重計算のための数値
    let standardWeightCalcNum:Float = 22.0
    
    // BMI計算
    // BMI = 体重(kg) / 身長(m2)
    func calcBMI(weight: Float, height: Float) -> Float {
        var bMI:Float = 0.0;
        bMI = weight / height
        return bMI
    }
    
    // 標準体重計算
    // 標準体重(kg) = 22 * 身長(m2)
    func calcStandardWeight(height: Float) -> Float {
        var standardWeight:Float = 0.0
        standardWeight = (height * height) * standardWeightCalcNum
        standardWeight = floor(standardWeight * 10) / 10
        return standardWeight
    }
    
    // 男性基礎代謝量計算
    func manCalcBasalMetabolicRate(weight: Float, height: Float, age:Int) -> Int {
        let basalMetabolicRate0: Double = Double(13.397 * weight)
        let basalMetabolicRate1: Double = Double(4.799 * (height * 100))
        let basalMetabolicRate2: Double =  Double(-5.677 * Float(age) + 88.362)
        let basalMetabolicRate: Int = Int(floor(basalMetabolicRate0 + basalMetabolicRate1 + basalMetabolicRate2))

        return basalMetabolicRate
    }
    
    // 女性基礎代謝量計算
    func womanCalcBasalMetabolicRate(weight: Float, height: Float, age:Int) -> Int {
        let basalMetabolicRate0: Double = Double(9.247 * weight)
        let basalMetabolicRate1: Double = Double(3.098 * (height * 100))
        let basalMetabolicRate2: Double =  Double(-4.33 * Float(age) + 447.593)
        let basalMetabolicRate: Int = Int(floor(basalMetabolicRate0 + basalMetabolicRate1 + basalMetabolicRate2))
        return basalMetabolicRate
    }
    
    // 必要推定エネルギー計算
    // 必要推定エネルギー量(kcal/日) = 基礎代謝量 * 身体活動レベル指数
    func calcRequiredEnergy(basalMetabolicRate: Int, physicalActiveLevel: Float) -> Int {
        let RequiredEnergy: Int = Int(Float(basalMetabolicRate) * physicalActiveLevel)
        return RequiredEnergy
    }
    
    // 誕生日から年齢を求める
    func calcAge(birth: String,calcNow: String) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        // 誕生日を年月日に分ける
        let birthY = Int(birth.prefix(4))
        let birthM = Int(birth[birth.index(birth.startIndex, offsetBy: 4)..<birth.index(birth.startIndex, offsetBy: 6)])
        let birthD = Int(birth[birth.index(birth.startIndex, offsetBy: 6)..<birth.index(birth.startIndex, offsetBy: 8)])
        // 登録日を年月日に分ける
        let nowY = Int(calcNow.prefix(4))
        let nowM = Int(calcNow[calcNow.index(calcNow.startIndex, offsetBy: 4)..<calcNow.index(calcNow.startIndex, offsetBy: 6)])
        let nowD = Int(calcNow[calcNow.index(calcNow.startIndex, offsetBy: 6)..<calcNow.index(calcNow.startIndex, offsetBy: 8)])

        let birthDate = DateComponents(calendar: calendar, year: birthY, month: birthM, day: birthD).date!
        let now = DateComponents(calendar: calendar, year: nowY, month: nowM, day: nowD).date!
        let age = calendar.dateComponents([.year], from: birthDate, to: now).year!
        return age
    }
    
    // 必要食事量計算
    func calcAmountOfFood(requiredEnergy : Int) -> Float {
        let amountOfFood: Float = floor(Float(requiredEnergy / 200) * 10) / 10
        return amountOfFood
    }
}
