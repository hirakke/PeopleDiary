//
//  AddDiaryView.swift
//  hitonikki
//
//  Created by Keiju Hiramoto on 2025/06/03.
//

import SwiftUI
import SwiftData

struct AddDiaryView: View {
    @State private var navigateToDiary = false
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss //戻る処理
    @Binding var isPresented: Bool
    @Query private var people: [Person]
    @Query private var diaryList: [DiaryEntry]
    
    @State private var name = ""
    @State private var content = ""
    @State private var nowDate = Date()
    @State private var dateText = ""
    @State private var showAlert = false
    
    @State private var savedPerson: Person? = nil
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP") //日本の時刻にする
        return formatter
    }()
    
    var body: some View{
            NavigationStack{
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                dismiss()//前の画面に戻るaction
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.system(.title))
                                    .frame(width: 70, height: 50)
                                    .background(Color.orange)
                                    .cornerRadius(25)
                                    .shadow(color:.gray.opacity(0.2), radius: 3,x:0,y:4)
                            }
        
                            
                            Spacer()
                            
                            Text(dateText.isEmpty ? dateFormatter.string(from: nowDate) : dateText)
                                .onAppear {
                                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                        self.nowDate = Date()
                                        dateText = dateFormatter.string(from: nowDate)
                                    }
                                }//今日の日付を表示
                                .font(.title)
                                .bold()
                            
                            Spacer()
                            
                            //チェックボタン
                            
                            Button(action: {
                                saveEntry()//保存の関数を呼び出し
                            }) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.system(.title))
                                    .frame(width: 70, height: 50)
                                    .background(Color.orange)
                                    .cornerRadius(25)
                                    .shadow(color:.gray.opacity(0.2), radius: 3,x:0,y:4)
                                
                            }
                            .navigationDestination(item: $savedPerson){ person in
                                PeopleDiaryView(person: person, isPresented: $isPresented)
                            }
                            Spacer()
                            /*
                             .fullScreenCover(item: $savedPerson){ person in
                             PeopleDiaryView(person: person, isPresented: $isPresented)
                             */
                        }
                        .alert("すべての項目を入力してください", isPresented: $showAlert) {
                            Button("OK", role: .cancel) {}
                        }//showAlertの時はポップアップでアラート
                    }
                }
                // 名前入力欄
                TextField("名前を入力してください", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .font(.headline)
                    .padding()
                    .shadow(color:.gray.opacity(0.2),radius:3,x:0,y:2)
                
                // 日記入力欄
        ZStack(alignment: .topLeading) {
         
                
                    TextEditor(text: $content)
              
                .frame(height: 600)
                .font(.headline)
                .overlay(
                               RoundedRectangle(cornerRadius: 10)
                                   .stroke(Color.gray, lineWidth: 0.1)
                           )
            
                
                        
                        .border(Color.gray.opacity(0.1), width: 1)
                        .cornerRadius(4)
                        .padding(5)
                        
                        
                    
                    if content.isEmpty {
                        Text("ここに文字を入力してください。")
                            .foregroundColor(.secondary)
                            .padding()
                            .font(.headline)
                    }
                }
        
                .padding(8)
                Spacer()
                
                /*NavigationLink(
                 destination: {
                 Group{
                 if let saved = savedPerson {
                 PeopleDiaryView(person: saved, isPresented: $isPresented)
                 } else {
                 // fallback View が必要（空ViewでもOK）
                 EmptyView()
                 }
                 }
                 },
                 isActive: $navigateToDiary,
                 label: {
                 EmptyView()
                 }
                 )
                 .hidden()
                 
                 */
            
            
        
    }
    
        private func saveEntry() {
            guard !name.isEmpty, !content.isEmpty else {
                showAlert = true
                return
            }
            // Person を既存から探すか、新規作成
            let person = people.first(where: { $0.name == name }) ?? {
                let newPerson = Person(name: name)
                context.insert(newPerson)
                return newPerson
            }()
            
            // DiaryEntry を作成して person に紐付け
            let diary = DiaryEntry(date: Date(), content: content)
            diary.person = person
            person.diaryEntries.append(diary)
            
            // 挿入と保存
            context.insert(diary)
            try? context.save()
            
            savedPerson = person
            navigateToDiary = true
        }
    
    
    }

    
    
    #Preview {
        AddDiaryView(isPresented: .constant(true))
        
        //$をつける→Binding
        //
        
    }
