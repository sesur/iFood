import SwiftUI

struct ItemDetailsView: View {
    
    let viewModel: RecipeViewModel
    
    init(viewModel: RecipeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            ZStack {
                Image(viewModel.imageName)
                    .resizable()
                    .imageScale(.medium)
                
                let gradient = Gradient(colors: [.black.opacity(0.65), .clear])
                LinearGradient(gradient: gradient,
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
            }
            .edgesIgnoringSafeArea(.top)
            
            
            Text(viewModel.title)
                .font(.title2)
                .foregroundStyle(.black)
                .padding(.all, 16)
            
            VStack {
                Text(viewModel.instructions)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    let viewModel = RecipeViewModel(
        title: "Title",
        instructions: "instructions",
        imageName: "imageName"
    )
    return ItemDetailsView(viewModel: viewModel)
}
