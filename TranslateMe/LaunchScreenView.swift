import SwiftUI

struct LaunchScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color(red: 47/255, green: 54/255, blue: 64/255)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    // Main logo and title
                    VStack(spacing: 20) {
                        Image("translateicon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 120)
                            .foregroundColor(Color(red: 231/255, green: 76/255, blue: 60/255))
                        
                        Text("TranslateMe")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 0.9
                            self.opacity = 1.0
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 5) {
                        Text("Aryan Lakhani")  
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        Text("Z-Number Z23724811")  
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .opacity(opacity)
                    .padding(.bottom, 30)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    LaunchScreenView()
} 
