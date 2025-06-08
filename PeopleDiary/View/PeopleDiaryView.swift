//
//  PeopleDiaryView.swift
//  PeopleDiary
//
//  Created by Keiju Hiramoto on 2025/06/04.
//

import SwiftUI
import SwiftData

struct PeopleDiaryView: View {
    let person: Person
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    @Query private var allEntries: [DiaryEntry]
    
    var filteredEntries: [DiaryEntry] {
        allEntries.filter { $0.person === person }//指定された人と一致する日記を表示
    }
    
    var totalPoints: Int {
        filteredEntries.count * 50
    }
    
    var lastUpdate: Date? {
        filteredEntries.map { $0.date }.max()//日付で最も大きいものを
    }
    
    var tagText: String {
        switch totalPoints {
        case 0..<100: return "まだまだ"
        case 100..<200: return "これから"
        default: return "まだまだ"
        }
    }
    
    var body: some View {
        
        VStack {
            HStack{
                Spacer()
                Text("\(person.name)")
                    .font(.title)
                    .fontWeight(.bold)
                   Spacer()
                    
             /*   Button(action: {
                    isPresented = false//画面切り替えのスイッチオフ
                } ){
                    Image(systemName: "xmark")
                        .frame(width: 50, height: 50)
                        .background(Color.orange)
                        .foregroundStyle(.white)
                        .bold()
                        .cornerRadius(30)
                }
                /*.fullScreenCover(isPresented: $isPresented) {
                    ContentView()
                }
                .padding()
                 */
              */
            }
                HStack{
                    Text("日記: \(filteredEntries.count)")
                    Text("親密度: \(totalPoints)")
                    Text("\(tagText)")
                }
                .padding()
                
                
                
            ScrollView {
                ForEach(filteredEntries) { diary in
                    HStack{
                        Text(" \(diary.date.formatted(.dateTime.year().month().day()))")
                            .foregroundStyle(.secondary)
                        Divider()//縦線
                            .frame(height:110)
                            .background(.black)
                        Text(diary.content)
                            .padding()
                            .frame(width:233,height:136)
                    }
                    .lineLimit(3)//contentの行数制限
                    
                    .frame(width:376,height:136)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.1),radius: 10,x: 0,y: 4)
                    
                    
                    
                    
                    
                    
                }}
                }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(.title))
                            .frame(width: 70, height: 50)
                            .background(Color.orange)
                            .cornerRadius(25)
                            .padding(10)
                        
                    }
                }
            }
        }
        
            
        }
    }




#Preview {
    let container = SampleData.sampleContainer()
    let person = try! container.mainContext.fetch(FetchDescriptor<Person>()).first!

    PeopleDiaryView(person: person, isPresented: .constant(true))
        .modelContainer(container)
}
