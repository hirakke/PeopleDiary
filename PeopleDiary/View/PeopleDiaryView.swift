//
//  PeopleDiaryView.swift
//  PeopleDiary
//
//  Created by Keiju Hiramoto on 2025/06/04.
//

import SwiftUI
import SwiftData

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


struct PeopleDiaryView: View {
    let person: Person
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    @Query private var allEntries: [DiaryEntry]
    
    var filteredEntries: [DiaryEntry] {
        allEntries.filter { $0.person === person }//指定された人と一致する日記を表示
    }
    
    var lastUpdate: Date? {
        filteredEntries.map { $0.date }.max()//日付で最も大きいものを
    }
    
    private var tagColor: Color {
        switch tagText {
        case "知り合い": return Color(hex: "#A0C4FF").opacity(0.9)    // 淡い水色
        case "話し相手": return Color(hex: "#72EFDD").opacity(0.9)    // 明るいシアン
        case "ともだち": return Color(hex: "#64DFDF").opacity(0.9)    // 青緑@
        case "仲良し": return Color(hex: "#80ED99").opacity(0.9)      // 若草色
        case "親友": return Color(hex: "#008000").opacity(0.7)        // 明るい黄緑 薄くなるのやだ
        case "大親友": return Color(hex: "#FFD166").opacity(0.9)      // 濃いめ黄色
        case "大大親友": return Color(hex: "#FF9F1C").opacity(0.9)    // 橙色
        case "心の友": return Color(hex: "#EF476F").opacity(0.9)      // 鮮やかなピンク
        case "ほぼ家族": return Color(hex: "#6A4C93").opacity(0.9)    // 紫
        default: return Color(hex: "#CCCCCC").opacity(0.4)           // グレー
        }
    }
    
    var tagText: String {
        switch person.totalPoints {
        case 0..<150:
            return "知り合い"
        case 150..<300:
            return "話し相手"
        case 300..<450:
            return "ともだち"
        case 450..<600:
            return "仲良し"
        case 600..<750:
            return "親友"
        case 750..<900:
            return "大親友"
        case 900..<1050:
            return "大大親友"
        case 1050..<1200:
            return "心の友"
        default:
            return "ほぼ家族"
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    var progress: Double {
        let thresholds = [0, 150, 300, 450,600,750,900,1050,1200]
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
                                        .trim(from: 0, to: Double(person.totalPoints) / 1050)
                                        .stroke(
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
                                        Text("\(Int(Double(person.totalPoints)))")
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
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
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
                                        .frame(width: 230, height: 136)
                                }
                                .lineLimit(3)
                                .frame(maxWidth:.infinity)
                                .frame(height: 136)
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
