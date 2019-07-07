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
 
    var userName: String = ""
    var userPicture: UIImage? = nil
    var birth: Date? = nil
    var sex: String = ""
    var physicalActiveLevel: String = ""
    var goalText: String = ""
    var amountOfFood: Float = 0.0
    var bmi: Float = 0.0
    
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
    
    func setGoalText(goalText: String) -> Void {
        self.goalText = goalText
    }
    
}
