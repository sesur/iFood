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
            
            VStack(alignment: .leading) {
                Spacer()
                Text(viewModel.title)
                    .foregroundStyle(.white)
                    .font(.title3)
            }
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 6, trailing: 0))
        }
        .cornerRadius(10)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

#Preview {
    let vm = RecipeViewModel(title: "Title", instructions: "instructions", imageName: "imageName")
    return SubmenuView(viewModel: vm)
}
