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
        let viewModel = SubmenuViewModel(properties: properties, recipes: recipes)
        
        submenuViewCntroller.viewModel = viewModel
        submenuViewCntroller.viewModel?.properties.submenuAction = { [weak self] item in
            self?.showDetails(item)
        }
        
        navigationController.pushViewController(submenuViewCntroller, animated: true)
    }
     
    //ShowDetailsViewController
    func showDetails(_ recipe: Recipe?) {
        guard let recipe = recipe else { return }
        let itemDetailsView = ItemDetailsView(recipe: recipe)
        let itemHostingView = UIHostingController(rootView: itemDetailsView)
        navigationController.pushViewController(itemHostingView, animated: true)
    }
}

struct SubmenuViewModel {
    var properties: ItemProperties
    let recipes: [Recipe]
    
    func recipeViewModels() -> [RecipeViewModel] {
        return recipes.map { recipe in
            RecipeViewModel(title: recipe.title,
                            instructions: recipe.instructions,
                            imageName: recipe.imageName)
        }
    }
}

struct ItemProperties {
    let id: Int
    var submenuAction: ((Recipe) -> Void)?
    
    init(id: Int,
         submenuAction: ((Recipe) -> Void)? = nil) {
        self.id = id
        self.submenuAction = submenuAction
    }
}

struct RecipeViewModel {
    let title: String
    let instructions: String
    let imageName: String
}
