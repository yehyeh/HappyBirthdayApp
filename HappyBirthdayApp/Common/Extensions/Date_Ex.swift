//
//  Date_Ex.swift
//  HappyBirthdayApp
//
//  Created by Yehonatan Yehudai on 16/05/2024.
//

import Foundation

extension Date {
    func monthsSinceNow() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month], from: self, to: now)
        return (components.year ?? 0) * 12 + (components.month ?? 0)
    }
}
