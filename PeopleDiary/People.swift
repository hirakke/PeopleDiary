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
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack(alignment:.center) {
                    Text(person.name)
                        .font(.headline)
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .frame(width: 85)

                    ZStack {
                        Circle()
                            .stroke(lineWidth: 8)
                            .opacity(0.3)
                            .foregroundColor(tagColor)
                            .frame(width: 50, height: 50)
                        

                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                            .foregroundColor(tagColor.opacity(0.9))
                            .rotationEffect(.degrees(-90))
                            .frame(width: 50, height: 50)

                        Text(tagText)
                            .font(.caption2)
                            .bold()
                            .foregroundColor(.black)
                    }
               
                    //.padding()
                }
                //Divider()
                VStack(alignment: .leading, spacing: 8){
                    HStack(spacing: 6) {
                        Image(systemName: "person")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("親密度:")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .fontWeight(.medium)
                        Text("\(person.totalPoints)")
                            .font(.caption2)
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                    }
                    //.padding(.horizontal, 6)
                     
                 /*
                 Text("\(person.totalPoints)")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.bottom,3)
                        .padding(.horizontal,3)
                 */
                    
                    HStack(spacing: 6) {
                        Image(systemName: "note.text")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("日記数:")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .fontWeight(.medium)
                        Text("\(filteredEntries.count)")
                            .font(.caption2)
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                    }
                    //.padding(.horizontal, 6)
                   
                    HStack (spacing:6){
                        Image(systemName: "clock.arrow.trianglehead.2.counterclockwise.rotate.90")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("更新日")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .fontWeight(.medium)
                        
                        if let lastUpdate = filteredEntries.map({ $0.date }).max() {
                            Text(dateFormatter.string(from: lastUpdate))
                                .font(.caption2)
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                        } else {
                            Text("未登録")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    //.padding(.horizontal, 6)
                    
                }
                
            }
            .padding()
        
        }
        .frame(height: 140)
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 6)
        /*
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal)
         */
    }
    
    var progress: Double {
        let thresholds = [0, 150, 300, 450,600,750,900,1050]
        guard let currentIndex = thresholds.lastIndex(where: { person.totalPoints >= $0 }) else {
            return 0.0
        }
        let start = thresholds[currentIndex]
        let end = (currentIndex + 1 < thresholds.count) ? thresholds[currentIndex + 1] : start + 1
        if end == start { return 1.0 }
        let progressInRange = Double(person.totalPoints - start) / Double(end - start)
        return max(0.0, min(progressInRange, 1.0))
    }
    
    private var tagColor: Color {
        switch tagText {
        case "知り合い": return Color.mint.opacity(0.8)
        case "話相手": return Color.blue.opacity(0.8)
        case "ともだち": return Color.green.opacity(0.8)
        case "なかいい": return Color.teal.opacity(0.8)
        case "したとも": return Color.orange.opacity(0.8)
        case "まぶだち": return Color.pink.opacity(0.8)
        case "心のとも": return Color.purple.opacity(0.8)
        case "ほぼ家族": return Color.red.opacity(0.8)
        default: return Color.gray.opacity(0.4)
        }
    }
    
    private var tagText: String {
        let points = person.totalPoints
        switch points {
        case 0..<150:
            return "知り合い"
        case 150..<300:
            return "話相手"
        case 300..<450:
            return "ともだち"
        case 450..<600:
            return "なかいい"
        case 600..<750:
            return "したとも"
        case 750..<900:
            return "まぶだち"
        case 900..<1050:
            return "心のとも"
        default:
            return "ほぼ家族"
        }
    }
}

#Preview {
    let modelContainer = try! ModelContainer(for: Person.self, DiaryEntry.self)
    let previewPerson = Person(name: "太郎")
    return People(person: previewPerson)
        .modelContainer(modelContainer)
}
