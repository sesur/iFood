import SwiftUI

struct SubmenuView: View {
    var viewModel: RecipeViewModel
    
    private static let gradient = Gradient(colors: [.clear, .black.opacity(0.45)])
    private let linearGradient = LinearGradient(gradient: gradient,
                                        startPoint: .topTrailing,
                                        endPoint: .bottomLeading)
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(viewModel.imageName)
                .resizable()
                .imageScale(.large)

            linearGradient
                .overlay(alignment: .bottomLeading) {
                    Text(viewModel.title)
                        .foregroundStyle(.white)
                        .font(.title3)
                        .padding(.all, 6)
                }
        }
        .cornerRadius(10)
        .padding(.all, 0)
    }
}

#Preview {
    let vm = RecipeViewModel(title: "Title", instructions: "instructions", imageName: "imageName")
    return SubmenuView(viewModel: vm)
}
