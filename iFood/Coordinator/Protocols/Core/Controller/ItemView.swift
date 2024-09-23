import SwiftUI

struct ItemView: View {
    var items: [RecipeViewModel]?
    weak var coordinator: SubmenuCoordinator?
    
    private struct Constants {
        static let columnNumbers = 2
        static let itemHeight: CGFloat = 200
        static let padding: CGFloat = 8
    }
    
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: Constants.columnNumbers)
    }
    
    var body: some View {
        if let items = items {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(items) { item in
                        SubmenuView(viewModel: item)
                            .frame(height: Constants.itemHeight)
                            .onTapGesture {
                                coordinator?.displayItemDetails(item)
                            }
                    }
                }
            }
            .padding(.horizontal, Constants.padding)
        }
    }
}
