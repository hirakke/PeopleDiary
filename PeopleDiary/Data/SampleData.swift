//
//  SampleData.swift
//  PeopleDiary
//
//  Created by Keiju Hiramoto on 2025/06/04.
//

// SampleData.swift

import Foundation
import SwiftData

struct SampleData {
    @MainActor static func sampleContainer() -> ModelContainer {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Person.self, DiaryEntry.self, configurations: config)

            // 人物
            let person1 = Person(name: "浦島太郎")
            let person2 = Person(name: "花咲か爺さん")
            let person3 = Person(name: "金太郎")

            // 日記
            let diary1 = DiaryEntry(date: .now, content: "助けた亀に連れられて竜宮城へ。")
            let diary2 = DiaryEntry(date: .now, content: "おじいさんに灰をまいたら花が咲いた。")
            let diary3 = DiaryEntry(date: .now, content: "金太郎と仲良くなった。")

            // 関係付け
            person1.diaryEntries.append(diary1)
            diary1.person = person1

            person2.diaryEntries.append(diary2)
            diary2.person = person2

            person3.diaryEntries.append(diary3)
            diary3.person = person3

            // 挿入
            for person in [person1, person2, person3] {
                container.mainContext.insert(person)
            }

            for diary in [diary1, diary2, diary3] {
                container.mainContext.insert(diary)
            }

            return container
        } catch {
            fatalError("サンプルデータ失敗: \(error)")
        }
    }
}


