//
//  AddDiaryView.swift
//  hitonikki
//
//  Created by Keiju Hiramoto on 2025/06/03.
//

import SwiftUI
import SwiftData

struct AddDiaryView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss //戻る処理
    
    @Query private var people: [Person]
    @Query private var diaryList: [DiaryEntry]
    
    @State private var name = ""
    @State private var content = ""
    @State private var nowDate = Date()
    @State private var dateText = ""
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP") //日本の時刻にする
        return formatter
    }()
    
    var body: some View {
        VStack {
            // ヘッダー
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Text("戻る")
                        .font(.title3)
                        .bold()
                }
                .padding(.leading)
                
                Spacer()
                
                Text(dateText.isEmpty ? dateFormatter.string(from: nowDate) : dateText)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            self.nowDate = Date()
                            dateText = dateFormatter.string(from: nowDate)
                        }
                    }
                    .font(.title3)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    saveEntry()
                    dismiss()
                }) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.orange)
                }
                .padding()
            }
            
            // 名前入力欄
            TextField("名前を入力してください", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            // 日記入力欄
            ZStack(alignment: .topLeading) {
                TextEditor(text: $content)
                    .frame(height: 150)
                    .padding(.horizontal)
                    .border(Color.gray.opacity(0.5), width: 1)
                
                if content.isEmpty {
                    Text("ここに文字を入力してください。")
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                        .padding(.horizontal, 12)
                        .allowsHitTesting(false)
                }
            }
            .padding(.top, 8)
            
            Spacer()
        }
    }
    
    func saveEntry() {
        guard !name.isEmpty, !content.isEmpty else { return }
        
        let person = people.first(where: { $0.name == name }) ?? {
            let newPerson = Person(name: name)
            context.insert(newPerson)
            return newPerson
        }()
        
        let entry = DiaryEntry(date: nowDate, content: content, person: person)
        context.insert(entry)
        //person.totalPoints += 50
        
        try? context.save()
    }
}
    
    
    #Preview {
        AddDiaryView()
    }

