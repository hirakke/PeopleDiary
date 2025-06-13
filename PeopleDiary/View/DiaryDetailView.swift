//
//  DiaryView.swift
//  PeopleDiary
//
//  Created by Keiju Hiramoto on 2025/06/04.
//

import SwiftUI
import SwiftData

struct DiaryDetailView: View {
    let diary: DiaryEntry
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack{
            Color(red: 255/255, green: 248/255, blue: 219/255)
                .ignoresSafeArea()
            
            VStack() {
                Text(diary.date.formatted(.dateTime.year().month().day()))
                    .font(.title)
                    .foregroundColor(.black)
                
                Text(diary.person?.name ?? "不明な人物")
                ZStack(alignment:.topLeading){
                    RoundedRectangle(cornerRadius:15)
                    Color(.white)
                        .shadow(color:.gray.opacity(0.4),radius:4,x:0,y:4)
                    Text(diary.content)
                        .font(.body)
                        .foregroundColor(.black)
                        .padding()
                
                }
                    
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    let container = SampleData.sampleContainer()
    let context = container.mainContext

    // 例として最初のDiaryEntryを取得
    let diary = try! context.fetch(FetchDescriptor<DiaryEntry>()).first!

    return DiaryDetailView(diary: diary)
        .modelContainer(container)
}
