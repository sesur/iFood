import UIKit

protocol FoodCategoryProtocol {
    func retrieveCategories() -> [FoodCategory]
}

protocol FoodRecipeProtocol {
    func retrieveRecipes() -> [Recipe]
}

class FoodServiceState: FoodCategoryProtocol, FoodRecipeProtocol {
 
    let service: FoodServiceComposer
    
    init(service: FoodServiceComposer) {
        self.service = service
    }
    
    func retrieveCategories() -> [FoodCategory] {
        service.getCategories()
    }
    
    func retrieveRecipes() -> [Recipe] {
        service.getRecipes()
    }
}
