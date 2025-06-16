import SwiftUI
import SwiftData

struct CalendarView: View {
    @Binding var selectedDate: Date
    var diaryDates: [Date]
    var onDateSelected: (Date) -> Void
    var forDate: Date
    @State private var currentMonth: Date

    private let calendar = Calendar.current
    private var currentMonthDates: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else { return [] }
        var dates: [Date] = []

        // Adjust to start from Monday
        var startDate = monthInterval.start
        let weekday = calendar.component(.weekday, from: startDate)
        let weekdayIndex = (weekday + 5) % 7 // Convert Sunday=1...Saturday=7 to Monday=0...Sunday=6

        if let adjustedStart = calendar.date(byAdding: .day, value: -weekdayIndex, to: startDate) {
            startDate = adjustedStart
        }

        for i in 0..<42 { // 6 weeks grid
            if let date = calendar.date(byAdding: .day, value: i, to: startDate) {
                dates.append(date)
            }
        }
        return dates
    }

    private func isSameDay(_ d1: Date, _ d2: Date) -> Bool {
        calendar.isDate(d1, inSameDayAs: d2)
    }

    private func hasDiary(on date: Date) -> Bool {
        diaryDates.contains { isSameDay($0, date) }
    }

    init(selectedDate: Binding<Date>, diaryDates: [Date], onDateSelected: @escaping (Date) -> Void) {
        self._selectedDate = selectedDate
        self.diaryDates = diaryDates
        self.onDateSelected = onDateSelected
        self.forDate = Date()
        self._currentMonth = State(initialValue: selectedDate.wrappedValue)
    }

    var body: some View {
        VStack {
            
            HStack {
                Button(action: {
                    if let newMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
                        currentMonth = newMonth
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.orange)
                }
                Spacer()
                Text(monthYearFormatter.string(from: currentMonth))
                    .font(.headline)
                Spacer()
                Button(action: {
                    if let newMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
                        currentMonth = newMonth
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.orange)
                }
            }
            .padding(.horizontal)
            .padding(.top, 4)
            Divider()
                .padding(.horizontal)
                .padding(.bottom, 4)

            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                ForEach(currentMonthDates, id: \.self) { date in
                    if calendar.isDate(date, equalTo: currentMonth, toGranularity: .month) {
                        VStack {
                            Text("\(calendar.component(.day, from: date))")
                                .foregroundColor(isSameDay(date, Date()) ? .white : .black)
                                .padding(8)
                                .background(isSameDay(date, Date()) ? Color.red : Color.clear)
                                .clipShape(Circle())
                                .shadow(color:.gray.opacity(0.5),radius: 3,x:0,y:3)
                            if hasDiary(on: date) {
                                Circle()
                                    .fill(Color.orange)
                                    .frame(width:6,height:6)
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(width:6,height:6)
                            }
                        }
                        .onTapGesture {
                            selectedDate = date
                            onDateSelected(date)
                        }
                    } else {
                        Color.clear.frame(height: 44)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color.white)
        .cornerRadius(12)
    }

    private var weekdays: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.shortWeekdaySymbols ?? []
    }

    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }
}

struct ContentView: View {

    @State private var date = Date()
    @State var isPresented: Bool = false
    @State private var selectedDate = Date()
    @State private var navigateToDiary = false
    @State private var showAlert = false
    @Query private var people: [Person]
    @Query private var diaryEntry: [DiaryEntry]
    
    
    
    private func hasDiaryEntry(on date: Date) -> Bool {
        diaryEntry.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color(red: 255/255, green: 248/255, blue: 219/255)
                        .ignoresSafeArea()
                    
                    VStack() {
                        
                        CalendarView(selectedDate: $selectedDate, diaryDates: diaryEntry.map { $0.date }) { date in
                            selectedDate = date
                            navigateToDiary = true
                        }
                        .padding(.horizontal)
                        //.padding(.top)
                        .padding(.bottom, 16)
                        .shadow(color:.gray.opacity(0.2), radius:8)
                        
                        NavigationLink(
                            destination: DiaryListView(forDate: selectedDate),
                            isActive: $navigateToDiary
                        ) {
                            EmptyView()
                        }
                        .hidden()
                        
                        HStack(){
                            
                            Image(systemName:"person.3.sequence.fill")
                            Text("People")
                            Spacer()
                            Text("\(people.count)人")
                                .padding(.horizontal)
                            
                        }
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        
                        
                        ZStack(alignment: .bottom) {
                            ScrollView(.vertical) {
                                LazyVGrid(columns: [GridItem(.fixed(geometry.size.width/2-20)), GridItem(.fixed(geometry.size.width/2-20))], spacing: 10) {
                                    ForEach(people) { person in
                                        NavigationLink(destination:
                                                        PeopleDiaryView(person: person, isPresented: $isPresented)
                                        ) {
                                            People(person: person)
                                        }
                                    }
                                }
                            }
                            .background(Color.clear)
                            
                            Button(action: {
                                isPresented=true
                                //日記を一日一個にするならアラートを呼び出し
                                /*
                                 if hasDiaryEntry(on: Date()) {
                                 showAlert = true
                                 } else {
                                 isPresented = true
                                 }
                                 */
                            }) {
                                Image(systemName: "plus")
                                    .frame(width: 65, height: 65)
                                    .background(.orange.opacity(0.8))
                                    .cornerRadius(32.5)
                                    .foregroundColor(.white)
                                    .font(.system(size: 30, weight: .bold))
                                    .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                            }
                            //日記を一日一個にする場合、アラート＋遷移をキャンセル
                            /*
                             .alert("本日の日記はすでに追加されています", isPresented: $showAlert) {
                             Button("OK", role: .cancel) {}
                             
                             }
                             */
                            .fullScreenCover(isPresented: $isPresented) {
                                AddDiaryView(isPresented: $isPresented, forDate: Date())
                            }
                        }
                    }
                }
            }
        }
    }
}
        
