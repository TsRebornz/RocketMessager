//
//  RMLogger.swift
//  RocketMessager
//
//  Created by Anton Makarenkov on 19.02.25.
//

import Foundation

protocol RMLogger {
    func log(message: String)
}

extension RMLogger {
    func log(message: String) {
        #if DEBUG
        print(message)
        #endif
    }
}
