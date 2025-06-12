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
        //===は同じオブジェクトであると真ここではDiaryEntryの全てのうち￥
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    var body: some View {
        VStack {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(person.name)
                            .font(.subheadline)
                            .foregroundStyle(.black)
                            .fontWeight(.bold)
                            .frame(width:85,height:20,alignment:.center)
                        
                        ZStack {
                            Rectangle()
                                .frame(width: 60, height: 20)
                                .foregroundColor(.green.opacity(0.8))
                                .cornerRadius(5)
                            Text(tagText)
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                    //Divider()
                    VStack(alignment: .leading){
                        HStack {
                            Image(systemName: "person")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("親密度")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                        }
                        .padding(.top,3)
                        .padding(.horizontal,3)
                        Text("\(filteredEntries.count * 50)")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.bottom,3)
                            .padding(.horizontal,3)
                        
                        HStack {
                            Image(systemName: "note.text")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("日記数")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                        }
                        .padding(.horizontal,3)
                        Text("\(filteredEntries.count)")
                            .foregroundColor(.black)
                            .font(.headline)
                            .padding(.bottom,3)
                            .padding(.horizontal,3)
                        
                        
                        HStack {
                            Image(systemName: "clock.arrow.trianglehead.2.counterclockwise.rotate.90")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("更新日")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            if let lastUpdate = filteredEntries.map({ $0.date }).max() {
                                Text(dateFormatter.string(from: lastUpdate))
                                    .font(.caption)
                                    .foregroundColor(.black)
                            } else {
                                Text("未記録")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal,3)
                        
                    }
                    .padding(.horizontal)
                }
            
            }
        }
        .frame(width: 175, height: 160)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 4)
        .padding(.horizontal)
    }
    
    private var tagText: String {
        let points = filteredEntries.count * 50
        switch points {
        case 0..<100: return "まだまだ"
        case 100..<200: return "これから"
        default: return "仲良し"
        }
    }
}

#Preview {
    let modelContainer = try! ModelContainer(for: Person.self, DiaryEntry.self)
    let previewPerson = Person(name: "太郎")
    return People(person: previewPerson)
        .modelContainer(modelContainer)
}
