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

            // 仮の人と日記
            let person1 = Person(name: "浦島太郎")
            let person2 = Person(name: "花咲か爺さん")
            let person3 = Person(name: "金太郎")
            
            let diary1 = DiaryEntry(date: .now.addingTimeInterval(-86400 * 2), content: "助けた亀に連れられて竜宮城へ。", person: person1)
            let diary2 = DiaryEntry(date: .now, content: "おじいさんに灰をまいたら花が咲いた。", person: person2)
            let diary3 = DiaryEntry(date: .now.addingTimeInterval(86400), content: "金太郎と仲良くなった。", person: person3)
            // コンテナに挿入
            container.mainContext.insert(person1)
            container.mainContext.insert(person2)
            container.mainContext.insert(person3)
            container.mainContext.insert(diary1)
            container.mainContext.insert(diary2)
            container.mainContext.insert(diary3)

            return container
        } catch {
            fatalError("Failed to create sample container: \(error)")
        }
    }
}
