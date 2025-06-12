import SwiftUI
import SwiftData

struct CalendarView: View {
    @Binding var selectedDate: Date
    var diaryDates: [Date]
    var onDateSelected: (Date) -> Void

    @State private var currentMonth: Date

    private let calendar = Calendar.current
    private var currentMonthDates: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else { return [] }
        var dates: [Date] = []
        var date = monthInterval.start
        while date < monthInterval.end {
            dates.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
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
            .padding(.top)
            Divider()
                .padding(.horizontal)
            
                .padding(.bottom, 4)

            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                ForEach(currentMonthDates, id: \.self) { date in
                    VStack {
                        Text("\(calendar.component(.day, from: date))")
                            .foregroundColor(isSameDay(date, selectedDate) ? .white : .black)
                            .padding(8)
                            .background(isSameDay(date, selectedDate) ? Color.red : Color.clear)
                            .clipShape(Circle())
                            .shadow(color:.gray.opacity(0.5),radius: 3,x:0,y:3)
                        if hasDiary(on: date) {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 6, height: 6)
                        }
                    }
                    .onTapGesture {
                        selectedDate = date
                        onDateSelected(date)
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
        return formatter.shortWeekdaySymbols
    }

    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
}

struct ContentView: View {
    @State private var date = Date()
    @State var isPresented: Bool = false
    @State private var selectedDate = Date()
    @State private var navigateToDiary = false
    @Query private var people: [Person]
    @Query private var diaryEntry: [DiaryEntry]
    
    
    
    private func hasDiaryEntry(on date: Date) -> Bool {
        diaryEntry.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 255/255, green: 248/255, blue: 219/255)
                    .ignoresSafeArea()

                VStack() {
                    CalendarView(selectedDate: $selectedDate, diaryDates: diaryEntry.map { $0.date }) { date in
                        selectedDate = date
                        navigateToDiary = true
                    }
                    .padding(.horizontal)
                    .padding(.top, 32)
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
                        
                    }
                    .padding(.horizontal)
                    

                    ZStack(alignment: .bottom) {
                        ScrollView(.vertical) {
                            LazyVGrid(columns: [GridItem(.fixed(180)), GridItem(.fixed(180))], spacing: 15) {
                                ForEach(people) { person in
                                    NavigationLink(destination:
                                                    PeopleDiaryView(person: person, isPresented: $isPresented)) {
                                        People(person: person)
                                            .frame(width: 175, height: 160)
                                    }
                                }
                            }
                        }
                        .background(Color.clear)
                        
                        Button(action: {
                            isPresented = true
                        }) {
                            Image(systemName: "plus")
                                .frame(width: 65, height: 65)
                                .background(.orange.opacity(0.8))
                                .cornerRadius(32.5)
                                .foregroundColor(.white)
                                .font(.system(size: 30, weight: .bold))
                                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                        }
                        .fullScreenCover(isPresented: $isPresented) {
                            AddDiaryView(isPresented: $isPresented)
                        }
                    }
                }
            }
        }
    }
}
        

#Preview {
    ContentView()
        .modelContainer(SampleData.sampleContainer())
}
