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
    @Attribute(.unique) var name: String
    @Relationship(deleteRule: .cascade) var diaryEntries: [DiaryEntry] = [] //Relationをせってし、Personが消去された時それに紐づくDiaryEntryも削除される。

    var totalPoints: Int {
        let basePoints = diaryEntries.count * 30
        let contentPoints = diaryEntries.map { $0.content.count }.reduce(0, +)
        return basePoints + Int(Double(contentPoints) * 0.3)
    }

    var lastUpdate: Date? {
        diaryEntries.map(\.date).max()
        
    }

    var tagText: String {
        switch totalPoints {
        case 0..<150:
            return "知り合い"
        case 150..<300:
            return "話し相手"
        case 300..<450:
            return "ともだち"
        case 450..<600:
            return "仲良し"
        case 600..<750:
            return "親友"
        case 750..<900:
            return "大親友"
        case 900..<1050:
            return "大大親友"
        case 1050..<1200:
            return "心の友"
        default:
            return "ほぼ家族"
        }
    }
    init(name: String) {
        self.name = name
    }
}
