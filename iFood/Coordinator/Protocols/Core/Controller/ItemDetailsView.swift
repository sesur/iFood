import SwiftUI

struct ItemDetailsView: View {
    @State private var isZoomed = false
    let viewModel: RecipeViewModel
    
    init(viewModel: RecipeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                Image(viewModel.imageName)
                    .resizable()
                let gradient = Gradient(colors: [.black.opacity(0.65), .clear])
                LinearGradient(gradient: gradient,
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                
            }
            .edgesIgnoringSafeArea(.top)
            .aspectRatio(contentMode: isZoomed ? .fill : .fit)
            .onTapGesture {
                withAnimation {
                    isZoomed.toggle()
                }
            }
            
            
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
    let viewModel = RecipeViewModel(id: UUID(),
                                    categoryId: 1,
                                    title: "Title",
                                    instructions: "instructions",
                                    imageName: "imageName",
                                    select: { _ in })
    ItemDetailsView(viewModel: viewModel)
}
