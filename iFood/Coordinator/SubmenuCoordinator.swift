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
        let recipes = state.retrieveRecipes(with: categoryId)
        
        let items = recipes.map { item in
            RecipeViewModel(id: UUID(),
                            categoryId: categoryId,
                            title: item.title,
                            instructions: item.instructions,
                            imageName: item.imageName, 
                            select: { [weak self] viewModel in
                self?.displayItemDetails(viewModel)
            })
        }
        
        itemView.items = items
        let itemHostingView = UIHostingController(rootView: itemView)
        navigationController.pushViewController(itemHostingView, animated: true)
    }
     
    func displayItemDetails(_ viewModel: RecipeViewModel) {
        let itemDetailsView = ItemDetailsView(viewModel: viewModel)
        let itemHostingView = UIHostingController(rootView: itemDetailsView)
        navigationController.pushViewController(itemHostingView, animated: true)
    }
}
