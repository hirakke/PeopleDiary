//
//  Person.swift
//  PeopleDiary
//
//  Created by Keiju Hiramoto on 2025/06/04.
//

import SwiftUI
import SwiftData

@Model
class Person {
    var name: String
    var diaryEntries: [DiaryEntry] = []

    var totalPoints: Int {
        diaryEntries.count * 50
    }
    var lastUpdate: Date? {
        diaryEntries.map(\.date).max()
    }

    var tagText: String {
        switch totalPoints {
        case 0..<100:
            return "まだまだ"
        case 100..<200:
            return "これから"
        default:
            return "まだまだ"
        }
    }

    init(name: String) {
        self.name = name
    }
    //イニシャライザの必要性については確認する必要がある。
}
