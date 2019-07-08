//
//  ValidationErrorType.swift
//  debuet
//
//  Created by 片平駿介 on 2019/06/23.
//  Copyright © 2019 ShunsukeKatahira. All rights reserved.
//

import Foundation

struct ValidationErrorType: Error {

    public let message: String

    public init(_ message: String) {
        self.message = message
    }
}
