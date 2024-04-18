import SwiftUI

struct ItemDetailsView: View {
    
    let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        VStack {
            ZStack {
                Image(recipe.imageName)
                    .resizable()
                    .imageScale(.medium)
                
                let gradient = Gradient(colors: [.black.opacity(0.65), .clear])
                LinearGradient(gradient: gradient,
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
            }
            .edgesIgnoringSafeArea(.top)
            
            
            Text(recipe.title)
                .font(.title2)
                .foregroundStyle(.black)
                .padding(.all, 16)
            
            VStack {
                Text(recipe.instructions)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    let recipe = Recipe(
        id: 0,
        title: "Title",
        instructions: "instructions",
        imageName: "imageName"
    )
    return ItemDetailsView(recipe: recipe)
}
