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
        let totalCharacters = filteredEntries.map { $0.content.count }.reduce(0, +)
        return filteredEntries.count * 50 + Int(Double(totalCharacters) * 0.1)
    }
    
    var lastUpdate: Date? {
        filteredEntries.map { $0.date }.max()//日付で最も大きいものを
    }
    
    var tagText: String {
        switch totalPoints {
        case 0..<150:
            return "知り合い"
        case 150..<300:
            return "話相手"
        case 300..<450:
            return "ともだち"
        case 450..<600:
            return "なかいい"
        case 600..<750:
            return "したとも"
        case 750..<900:
            return "まぶだち"
        case 900..<1050:
            return "心のとも"
        default:
            return "ほぼ家族"
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    private var tagColor: Color {
        switch tagText {
        case "知り合い": return Color.mint.opacity(0.8)
        case "話相手": return Color.blue.opacity(0.8)
        case "ともだち": return Color.green.opacity(0.8)
        case "なかいい": return Color.teal.opacity(0.8)
        case "したとも": return Color.orange.opacity(0.8)
        case "まぶだち": return Color.pink.opacity(0.8)
        case "心のとも": return Color.purple.opacity(0.8)
        case "ほぼ家族": return Color.red.opacity(0.8)
        default: return Color.gray.opacity(0.4)
        }
    }
    
    var progress: Double {
        let thresholds = [0, 150, 300, 450,600,750,900,1050]
        guard let currentIndex = thresholds.lastIndex(where: { person.totalPoints >= $0 }) else {
            return 0.0
        }
        let start = thresholds[currentIndex]
        let end = (currentIndex + 1 < thresholds.count) ? thresholds[currentIndex + 1] : start + 1
        if end == start { return 1.0 }
        let progressInRange = Double(person.totalPoints - start) / Double(end - start)
        return max(0.0, min(progressInRange, 1.0))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 255/255, green: 248/255, blue: 219/255)
                    .ignoresSafeArea()
                VStack(alignment:.leading) {
                    
                    HStack{
                        Spacer()
                        Text("\(person.name)")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.yellow.opacity(0.6), Color.yellow.opacity(0.9)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(height: 110)
                                .shadow(color: Color.yellow.opacity(0.4), radius: 8, x: 0, y: 4)
                                .padding()
                            HStack{
                                ZStack {
                                    RoundedRectangle(cornerRadius:45)
                                        .frame(width:90,height:90)
                                        .foregroundColor(.white)
                                    Circle()
                                        .stroke(lineWidth: 10)
                                        .opacity(0.6)
                                        .foregroundColor(.green.opacity(0.8))
                                        .frame(width: 70, height: 70)
                                    
                                    Circle()
                                        .trim(from: 0, to: Double(totalPoints) / 1050)
                                        .stroke(
                                            /*AngularGradient(
                                             gradient: Gradient(colors:[.green, .yellow, .orange]),
                                             center: .center,
                                             startAngle: .degrees(0),
                                             endAngle: .degrees(360)
                                             ),
                                             */
                                            style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round)
                                        )
                                        .foregroundColor(.green.opacity(0.8))
                                        .rotationEffect(.degrees(-90))
                                        .frame(width: 70, height: 70)
                                    
                                    VStack(spacing: 0) {
                                        Text("親密度")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                        Text("\(Int(Double(totalPoints)))")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                    }
                                }
                                .padding(.horizontal)
                                ZStack{
                                    RoundedRectangle(cornerRadius:45)
                                        .frame(width:90,height:90)
                                        .foregroundColor(.white)
                                    Circle()
                                        .stroke(lineWidth: 10)
                                        .opacity(0.6)
                                        .foregroundColor(tagColor.opacity(0.8))
                                        .frame(width: 70, height: 70)
                                    
                                    Circle()
                                        .trim(from: 0, to:progress)
                                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                                        .foregroundColor(tagColor.opacity(0.8))
                                        .rotationEffect(.degrees(-90))
                                        .frame(width: 70, height: 70)
                                    
                                    Text("\(tagText)")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                        .frame(width: 45)
                                    
                                    
                                }
                                
                                .padding(.horizontal)
                                ZStack{
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(.white)
                                        .frame(width:90,height:90)
                                        .padding(10)
                                        .shadow(color: Color.yellow.opacity(0.4), radius: 4, x: 0, y: 4)
                                    
                                    
                                    
                                    VStack{
                                        Text("日記数")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Text("\(filteredEntries.count)")//IntからString
                                            .font(.largeTitle)
                                            .bold()
                                            .foregroundColor(.black)
                                    }
                                }
                                
                                
                                
                                
                                
                                
                                
                            }
                            .padding(.horizontal)
                        }
                    }
                    ScrollView {
                        ForEach(filteredEntries) { diary in
                            NavigationLink(destination: DiaryDetailView(diary: diary)) {
                                HStack {
                                    Text(" \(formattedDate(diary.date))")
                                        .foregroundStyle(.secondary)
                                    Divider()
                                        .frame(height: 110)
                                        .background(Color.black)
                                    
                                    Text(diary.content)
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
                        isPresented = false
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
    }
}



#Preview {
    let container = SampleData.sampleContainer()
    let person = try! container.mainContext.fetch(FetchDescriptor<Person>()).first!

    PeopleDiaryView(person: person, isPresented: .constant(true))
        .modelContainer(container)
}
