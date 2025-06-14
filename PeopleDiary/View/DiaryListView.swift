//
//  DiaryListView.swift
//  PeopleDiary
//
//  Created by Keiju Hiramoto on 2025/06/08.
//

import SwiftUI
import SwiftData

struct DiaryListView: View {
    var forDate: Date
    @Query private var diaryEntries: [DiaryEntry]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        let calendar = Calendar.current
        let filteredEntries = diaryEntries.filter {
            calendar.isDate($0.date, inSameDayAs: forDate)
        }

        ZStack {
            Color(red: 255/255, green: 248/255, blue: 219/255)
                .ignoresSafeArea()
            VStack {
                Text("\(formattedDate(forDate))の日記 ")
                    .font(.title2)
                    .foregroundColor(.black)
                    .bold()
                    .padding()

                if filteredEntries.isEmpty {
                    Text("この日の日記はまだありません。")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        
                            ForEach(filteredEntries) { entry in
                                NavigationLink(destination: DiaryDetailView(diary: entry)) {
                                HStack {
                                    Text(" \(formattedDate(entry.date))")
                                        .foregroundStyle(.secondary)
                                    Divider()
                                        .frame(height: 110)
                                        .background(.black)
                                    Text(entry.content)
                                        .padding()
                                        .frame(width: 233, height: 136)
                                }
                                .lineLimit(3)
                                .frame(width: 376, height: 136)
                                .background(Color.white)
                                .cornerRadius(15)
                                .padding(.horizontal)
                                .shadow(color: .gray.opacity(0.1), radius: 10, x: 0, y: 4)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
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
            }
        }
        //.navigationTitle("日記一覧")
    }
        
        func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            formatter.locale = Locale(identifier: "ja_JP")
            return formatter.string(from: date)
        }
    }

#Preview {
    DiaryListView(forDate: Date())
}
