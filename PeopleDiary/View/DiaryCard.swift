//
//  DiaryCard.swift
//  PeopleDiary
//
//  Created by Keiju Hiramoto on 2025/06/05.
//
//使用していないファイル
/*
import SwiftUI
import SwiftData

struct DiaryCard: View {
    @Environment(\.modelContext) private var context
    
    let diary: DiaryEntry
    let person: Person
    
    private var dateFormatter: DateFormatter {//dateFormatterというDateFormatter型の変数を作成
        let formatter = DateFormatter() //formatterという名前の定数にDateFormatter関数を代入
        formatter.dateFormat = "yyyy年MM月dd日"
        //formatter→DateFormatter()のdateFormatを設定
        return formatter
    }
    
    var body: some View {
                        VStack(alignment: .leading){
                            HStack{
                                Text(dateFormatter.string(from: diary.date))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(diary.content)
                                    .font(.body)
                                    .lineLimit(3)
                            }
                        }
                    
                
            .frame(width: 376, height: 136)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .gray.opacity(0.1),radius: 10,x: 0,y: 4)
            
            
            
        }
        
    }


#Preview {
    let container = SampleData.sampleContainer()
    let diary = try! container.mainContext.fetch(FetchDescriptor<DiaryEntry>()).first!
    let person = try!
        container.mainContext.fetch(FetchDescriptor<Person>()).first!
    
    return DiaryCard(diary: diary,person:person)
        .modelContainer(container)
}
*/
