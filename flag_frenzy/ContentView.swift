import SwiftUI

struct FlagImage: View{
    var content: Image
    var body: some View {
        content
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct LargeBlueFont: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.heavy))
            .foregroundColor(.blue)
    }
}

extension View{
    func largeBlueFont() -> some View{
        modifier(LargeBlueFont())
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var chosenFlag = ""
    @State private var noOfQuestions = 0
    @State private var finalQuestionDone = false
    var body: some View {
        ZStack{
            RadialGradient(stops:[
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ] , center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack{
                Spacer()
                
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 30){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.headline.weight(.bold))
                        
                        Text(countries[correctAnswer])
//                            .largeBlueFont()
                            .font(.largeTitle.weight(.heavy))
                    }
                    
                    ForEach(0..<3){ number in
                        Button{
                            // Button was tapped
                            flagTapped(number)
                        }label: {
                            FlagImage(content: Image(countries[number]))
//                                .clipShape(.capsule)
//                                .shadow(radius: 5)
                              
                        }
                        
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score : \(score)/\(noOfQuestions)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                    .padding(.horizontal, 20)
                    .background(Color(red:0.1, green:0.2 , blue:0.4))
                    .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: AskQuestion)
        } message: {
            if scoreTitle == "Wrong" {
                Text("That's the flag of \(chosenFlag)\nYour score is \(score) out of \(noOfQuestions)")
            }
            Text("Your score is \(score) out of \(noOfQuestions)")
        }
        .alert("Game Over",isPresented: $finalQuestionDone){
            Button("Restart Game" ,role: .cancel, action: RestartGame)
        } message: {
            Text("Your score was \(score) out of 8.")
        }
    }
    
    func flagTapped(_ number: Int){
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        }
        else{
            scoreTitle = "Wrong"
            chosenFlag = countries[number]
        }
        noOfQuestions += 1
        if noOfQuestions==8{
            finalQuestionDone = true
        }
        showingScore = true
    }
    
    func AskQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func RestartGame(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        noOfQuestions = 0
        score = 0
        showingScore = false
    }
    
}

#Preview {
    ContentView()
}
