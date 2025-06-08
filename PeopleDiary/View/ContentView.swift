import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var date = Date()
    @State var isPresented: Bool = false
    @Query private var people: [Person]
    @Query private var diaryEntry: [DiaryEntry]
    
    var body: some View {
        NavigationStack{
            VStack {
                
                DatePicker("Start Date",selection: $date,displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding()
                
                ZStack(alignment: .bottom){
                    ScrollView(.vertical) {
                        LazyVGrid(columns: [GridItem(.fixed(180)), GridItem(.fixed(180))], spacing: 16) {
                            ForEach(people) { person in
                                NavigationLink(destination:
                                                PeopleDiaryView(person:person, isPresented: $isPresented)){
                                    People(person: person)
                                    //Personクラスのperson変数に各people(データ)を代入して
                                        .frame(width:180,height:180)
                                    
                                }
                            }
                        }
                       
                    }
                    
                    Button(action:{
                        isPresented = true
                    }){
                        Image(systemName: "plus")
                            .frame(width:65,height:65)
                            .background(.orange.opacity(0.8))
                            .cornerRadius(32.5)
                            .font(.system(size: 30, weight: .bold, design: .default))
                            .foregroundColor(.white)
                        
                    }
                    
                    .fullScreenCover(isPresented: $isPresented){
                        AddDiaryView(isPresented: $isPresented)
                    }
                    
                    
                    
                }
                
            }
        }
        
        /*.background(
         Color(red:255,green:248,blue:219)
         .edgesIgnoringSafeArea(.all)
         )*/
    }
}
        


#Preview {
    ContentView()
        .modelContainer(SampleData.sampleContainer())
}
