//
//  People.swift
//  PeopleDiary
//
//  Created by Keiju Hiramoto on 2025/06/04.
//

import SwiftUI
import SwiftData

struct People: View {
    @Environment(\.modelContext) private var context
    let person : Person
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    var body: some View {
        
        VStack{
            VStack(alignment: .leading){
                HStack{
                    Text(person.name)
                        .font(.subheadline)
                        .foregroundStyle(.black)
                        .fontWeight(.bold)
                    ZStack{
                        Rectangle()
                            .frame(width: 59, height: 21)
                            .foregroundColor(.blue)
                            .cornerRadius(5)
                        Text("\(person.tagText)")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    
                }
                HStack(alignment:.center){
                    Image(systemName:"note.text")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("日記")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("\(person.diaryEntries.count)")
                
                HStack{
                    Image(systemName:"person.line.dotted.person")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("親密度")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("\(person.totalPoints)")
                
                HStack{
                    Image(systemName:"clock.arrow.trianglehead.2.counterclockwise.rotate.90")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("更新日")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                if let lastUpdate = person.lastUpdate{
                    Text(dateFormatter.string(from: person.lastUpdate!))
                        .font(.subheadline)
                }   else{
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
}
#Preview {
    let container = SampleData.sampleContainer()
    let person = try! container.mainContext.fetch(FetchDescriptor<Person>()).first!

    return People(person: person)
        .modelContainer(container)
}
