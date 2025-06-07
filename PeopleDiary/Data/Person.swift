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
}
