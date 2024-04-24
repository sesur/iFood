import UIKit

protocol FoodCategoryProtocol {
    func retrieveCategories() -> [FoodCategory]
}

protocol FoodRecipeProtocol {
    func retrieveRecipes(with id: Int) -> [Recipe]
}

class FoodServiceState: FoodCategoryProtocol, FoodRecipeProtocol {
 
    let service: FoodServiceComposer
    
    init(service: FoodServiceComposer) {
        self.service = service
    }
    
    func retrieveCategories() -> [FoodCategory] {
        service.getCategories()
    }
    
    func retrieveRecipes(with id: Int) -> [Recipe] {
        let recipes = service.getRecipes()
        return recipes.filter { $0.id == id }
    }
}
