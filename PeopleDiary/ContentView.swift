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
                    LazyVGrid(columns: [GridItem(.fixed(180)), GridItem(.fixed(180))], spacing: 16) {
                        ForEach(people) { person in
                            People(person: person)//Personクラスのperson変数に各people(データ)を代入して
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
    ContentView()
        .modelContainer(SampleData.sampleContainer())
}
