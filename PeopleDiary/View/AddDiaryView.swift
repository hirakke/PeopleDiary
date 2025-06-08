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
                
                // ヘッダー
                HStack {
                    
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
                    }
                    
                    .padding(.leading)
                    
                    Spacer()
                    
                    Text(dateText.isEmpty ? dateFormatter.string(from: nowDate) : dateText)
                        .onAppear {
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                self.nowDate = Date()
                                dateText = dateFormatter.string(from: nowDate)
                            }
                        }//今日の日付を表示
                        .font(.title3)
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
                        
                    }
                    .navigationDestination(item: $savedPerson){ person in
                        PeopleDiaryView(person: person, isPresented: $isPresented)
                    }
                    /*
                     .fullScreenCover(item: $savedPerson){ person in
                     PeopleDiaryView(person: person, isPresented: $isPresented)
                     */
                }
                .padding()
                .alert("すべての項目を入力してください", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                }//showAlertの時はポップアップでアラート
            }
            
            // 名前入力欄
            TextField("名前を入力してください", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            // 日記入力欄
            ZStack(alignment: .topLeading) {
                TextEditor(text: $content)
                    .frame(width:340,height: 500)
                
                    .padding()
                
                    .border(Color.gray.opacity(0.2), width: 1)
                    .cornerRadius(8)
                
                if content.isEmpty {
                    Text("ここに文字を入力してください。")
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 8)
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
