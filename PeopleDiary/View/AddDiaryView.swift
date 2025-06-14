//
//  AddDiaryView.swift
//  hitonikki
//
//  Created by Keiju Hiramoto on 2025/06/03.
//

import SwiftUI
import SwiftData

struct AddDiaryView: View {
    var forDate: Date
    @Binding var isPresented: Bool
    @State private var nowDate: Date

    @State private var navigateToDiary = false
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss //戻る処理
    @Query private var people: [Person]
    @Query private var diaryList: [DiaryEntry]
    
    @State private var name = ""
    @State private var content = ""
    @State private var dateText = ""
    @State private var showAlert = false
    
    @State private var savedPerson: Person? = nil
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
    
    init(isPresented: Binding<Bool>, forDate: Date) {
        self._isPresented = isPresented
        self.forDate = forDate
        self._nowDate = State(initialValue: forDate)
    }
    
    var body: some View{
        NavigationStack{
            ZStack {
                Color(red: 255/255, green: 248/255, blue: 219/255)
                    .ignoresSafeArea()
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
                        
                        Text(dateFormatter.string(from: forDate))
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
                    
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    
                    
                    
                    // 名前入力欄
                    TextField("名前を入力", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .shadow(color:.gray.opacity(0.2),radius:8,x:0,y:2)
                        .overlay(RoundedRectangle(cornerRadius:8).stroke(Color.white,lineWidth:4))
                    
                        .font(.title3)
                        .padding()
                        
                    
                    // 日記入力欄
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 4)
                            .padding(.horizontal)
                        
                        TextEditor(text: $content)
                            .padding()
                            .font(.body)
                            .frame(minHeight: 300)
                        
                        if content.isEmpty {
                            Text("内容を入力")
                                .foregroundColor(.gray.opacity(0.5))
                                .padding(.horizontal, 30)
                                .padding(.top, 16)
                                .font(.body)
                        }
                    }
                }
                
                
                
                Spacer()
            }
        }
    }
    
        private func saveEntry() {
            guard !name.trimmingCharacters(in: .whitespaces).isEmpty, !content.isEmpty else {
                showAlert = true
                return
            }
            let trimmedName = name.trimmingCharacters(in: .whitespaces)
            // Person を既存から探すか、新規作成
            let person = people.first(where: { $0.name == trimmedName }) ?? {
                let newPerson = Person(name: trimmedName)
                context.insert(newPerson)
                return newPerson
            }()
            
            // DiaryEntry を作成して person に紐付け
            let diary = DiaryEntry(date: forDate, content: content)
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
        AddDiaryView(isPresented: .constant(true), forDate: Date())
        
        //$をつける→Binding
        //
        
    }
