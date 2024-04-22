import UIKit
import SwiftUI

class SubmenuCoordinator: NSObject, Coordinator, MenuProtocol {

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
        showCategoryMenu()
    }
    
    //MARK:- MenuProtocol
    func showCategoryMenu() {
        let submenuViewCntroller = SubmenuViewController.instantiate()
        let recipes = state.retrieveRecipes(with: categoryId)
        
        let properties = ItemProperties(id: categoryId)
        
        let recipesViewModel = recipes.map { recipe in
                RecipeViewModel(title: recipe.title,
                                instructions: recipe.instructions,
                                imageName: recipe.imageName)
        }
        
        let viewModel = SubmenuViewModel(properties: properties, recipes: recipesViewModel)
        
        submenuViewCntroller.viewModel = viewModel
        submenuViewCntroller.viewModel?.properties.submenuAction = { [weak self] item in
            self?.showDetails(item)
        }
        
        navigationController.pushViewController(submenuViewCntroller, animated: true)
    }
     
    //ShowDetailsViewController
    func showDetails(_ viewModel: RecipeViewModel) {
        let itemDetailsView = ItemDetailsView(viewModel: viewModel)
        let itemHostingView = UIHostingController(rootView: itemDetailsView)
        navigationController.pushViewController(itemHostingView, animated: true)
    }
}

struct SubmenuViewModel {
    var properties: ItemProperties
    let recipes: [RecipeViewModel]
}

struct ItemProperties {
    let id: Int
    var submenuAction: ((RecipeViewModel) -> Void)?
    
    init(id: Int,
         submenuAction: ((RecipeViewModel) -> Void)? = nil) {
        self.id = id
        self.submenuAction = submenuAction
    }
}

struct RecipeViewModel {
    let title: String
    let instructions: String
    let imageName: String
}
