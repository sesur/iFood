import UIKit
import SwiftUI

class SubmenuCoordinator: NSObject, Coordinator {

    weak var parentCoordinator: MainCoordinator?
    var navigationController: UINavigationController
    let categoryId: Int
    let state: FoodServiceState
    
    init(navigationController: UINavigationController,
         state: FoodServiceState,
         categoryId: Int) {
        self.navigationController = navigationController
        self.state = state
        self.categoryId = categoryId
    }
    
    func start() {
        displaySubmenu()
    }
    
    private func displaySubmenu() {
        var itemView = ItemView()
        itemView.coordinator = self
        
        fetchRecipes { [weak self] recipes in
            DispatchQueue.main.async {
                self?.presentSubmenu(with: recipes, in: itemView)
            }
        }
    }
    
    private func fetchRecipes(completion: @escaping ([Recipe]) -> Void) {
        state.retrieveRecipes { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let item):
                let filtered = item.recipes.filter { $0.id == self.categoryId }
                completion(filtered)
                
            case .failure(let error):
                self.handleRecipeFetchError(error)
            }
        }
    }
    
    private func presentSubmenu(with recipes: [Recipe], in itemView: ItemView) {
        var updatedItemView = itemView
        updatedItemView.items = recipes.map(makeViewModel(from:))
        
        let hostingController = UIHostingController(rootView: updatedItemView)
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    private func makeViewModel(from recipe: Recipe) -> RecipeViewModel {
        RecipeViewModel(
            id: UUID(),
            categoryId: recipe.id,
            title: recipe.title,
            instructions: recipe.instructions,
            imageName: recipe.imageName,
            select: { [weak self] viewModel in
                self?.displayItemDetails(viewModel)
            }
        )
    }
    
    private func handleRecipeFetchError(_ error: Error) {
        print("Error retrieving recipes: \(error)")
    }
     
    func displayItemDetails(_ viewModel: RecipeViewModel) {
        let itemDetailsView = ItemDetailsView(viewModel: viewModel)
        let itemHostingView = UIHostingController(rootView: itemDetailsView)
        navigationController.pushViewController(itemHostingView, animated: true)
    }
}
