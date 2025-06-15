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
    @State private var isEditing = false
    @State private var editedContent: String

    init(diary: DiaryEntry) {
        self.diary = diary
        self._editedContent = State(initialValue: diary.content)
    }

    var body: some View {
        ZStack{
            Color(red: 255/255, green: 248/255, blue: 219/255)
                .ignoresSafeArea()
            
            VStack() {
                Text(diary.date.formatted(.dateTime.year().month(.twoDigits).day(.twoDigits).locale(Locale(identifier: "ja_JP"))).replacingOccurrences(of: "-", with: "/"))
                    .font(.title)
                    .foregroundColor(.black)
                    .bold()
                    .padding(.bottom)
                
                Text(diary.person?.name ?? "不明な人物")
                    .font(.largeTitle)
                    .bold()
                ZStack(alignment:.topLeading){
                    RoundedRectangle(cornerRadius:10 )
                        .fill(.white)
                        .shadow(color:.gray.opacity(0.4),radius:4,x:0,y:4)
                    if isEditing {
                        VStack(alignment:.leading){
                            Text("編集モード")
                                .padding(.top)
                                .padding(.horizontal)
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextEditor(text: $editedContent)
                                .font(.body)
                                .foregroundColor(.black)
                                .padding(.horizontal)
                        }
                    } else {
                        ScrollView{
                            Text(diary.content)
                                .font(.body)
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                
                }
                    
                
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(.title2))
                            .bold()
                            .frame(width: 70, height: 45)
                            .background(Color.orange)
                            .cornerRadius(25)
                            .shadow(color:.gray.opacity(0.2), radius: 3,x:0,y:4)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if isEditing {
                            diary.content = editedContent
                            try? diary.modelContext?.save()
                        }
                        isEditing.toggle()
                    }) {
                        Image(systemName: isEditing ? "checkmark" : "pencil")
                            .foregroundColor(.white)
                            .font(.system(.title2))
                            .bold()
                            .frame(width: 70, height: 45)
                            .background(Color.orange)
                            .cornerRadius(25)
                            .shadow(color:.gray.opacity(0.2), radius: 3,x:0,y:4)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
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
