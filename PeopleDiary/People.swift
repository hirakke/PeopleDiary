//
//  People.swift
//  PeopleDiary
//
//  Created by Keiju Hiramoto on 2025/06/04.


import SwiftUI
import SwiftData

struct People: View {
    @Environment(\.modelContext) private var context
    let person: Person

    @Query private var allEntries: [DiaryEntry]

    private var filteredEntries: [DiaryEntry] {
        allEntries.filter { $0.person === person }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(person.name)
                        .font(.subheadline)
                        .foregroundStyle(.black)
                        .fontWeight(.bold)
                    ZStack {
                        Rectangle()
                            .frame(width: 59, height: 21)
                            .foregroundColor(.blue)
                            .cornerRadius(5)
                        Text(tagText)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }

                HStack {
                    Image(systemName: "note.text")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("日記")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text("\(filteredEntries.count)")

                HStack {
                    Image(systemName: "person.line.dotted.person")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("親密度")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text("\(filteredEntries.count * 50)")

                HStack {
                    Image(systemName: "clock.arrow.trianglehead.2.counterclockwise.rotate.90")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("更新日")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                if let lastUpdate = filteredEntries.map({ $0.date }).max() {
                    Text(dateFormatter.string(from: lastUpdate))
                        .font(.subheadline)
                } else {
                    Text("未記録")
                        .font(.subheadline)
                }
            }
            .frame(width: 175, height: 165)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 4)
        }
        .background(Color.gray.opacity(0.1))
    }

    private var tagText: String {
        let points = filteredEntries.count * 50
        switch points {
        case 0..<100: return "まだまだ"
        case 100..<200: return "これから"
        default: return "まだまだ"
        }
    }
}
