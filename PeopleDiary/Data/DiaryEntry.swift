//
//  DiaryEntry.swift
//  PeopleDiary
//
//  Created by Keiju Hiramoto on 2025/06/04.
//

import SwiftUI
import SwiftData


@Model
class DiaryEntry {
    var date: Date
    var content: String
    var person: Person?

    init(date: Date, content: String, person: Person? = nil) {
        self.date = date
        self.content = content
        self.person = person
    }

    var contentLength: Int {
        content.count
    }
}
