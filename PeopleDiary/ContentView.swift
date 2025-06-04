import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var date = Date()
    @State private var isPresented: Bool = false
    @Query private var people: [Person]
    
    var body: some View {
        VStack {
            
            DatePicker("Start Date",selection: $date,displayedComponents: [.date])
                           .datePickerStyle(.graphical)
                           .padding()
            
            VStack{
                ScrollView(.vertical) {
                    LazyHGrid(rows: [GridItem(.fixed(180)), GridItem(.fixed(180))], spacing: 16) {
                        ForEach(people) { person in
                            People(person: person)
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 380)
                }
                Button(action:{
                    isPresented = true
                }){
                    Text("+")
                        .font(.system(size: 30, weight: .bold, design: .default))
                        .foregroundColor(.blue)
                }
                .fullScreenCover(isPresented: $isPresented){
                    AddDiaryView()
                }

                    
                    
                }
                
            }
        }
        
        /*.background(
            Color(red:255,green:248,blue:219)
                .edgesIgnoringSafeArea(.all)
        )*/
    }
        


#Preview {
    @MainActor
    struct PreviewWrapper: View {
        let container: ModelContainer

        init() {
            do {
                let config = ModelConfiguration(isStoredInMemoryOnly: true)
                container = try ModelContainer(for: Person.self, DiaryEntry.self, configurations: config)

                let person1 = Person(name: "浦島太郎")
                let person2 = Person(name: "金之助")

                let diary1 = DiaryEntry(date: Date(), content: "亀を助けた。", person: person1)
                let diary2 = DiaryEntry(date: Date(), content: "宝探しに出かけた。", person: person2)

                container.mainContext.insert(person1)
                container.mainContext.insert(person2)
                container.mainContext.insert(diary1)
                container.mainContext.insert(diary2)
            } catch {
                fatalError("Failed to create container: \(error)")
            }
        }

        var body: some View {
            ContentView()
                .modelContainer(container)
        }
    }

    return PreviewWrapper()
}
