import UIKit

protocol FoodCategoryProtocol {
    func retrieveCategories(completion: @escaping(FoodServiceComposer.ServiceResult) -> Void)
}

protocol FoodRecipeProtocol {
    func retrieveRecipes(with id: Int) -> [Recipe]
}

class FoodServiceState: FoodCategoryProtocol, FoodRecipeProtocol {
 
    let service: FoodServiceComposer
    
    init(service: FoodServiceComposer) {
        self.service = service
    }
    
    func retrieveCategories(completion: @escaping(FoodServiceComposer.ServiceResult) -> Void) {
        service.getCategoriesWithAsync(completion: completion)
    }
    
    func retrieveRecipes(with id: Int) -> [Recipe] {
        let recipes = service.getRecipes()
        return recipes.filter { $0.id == id }
    }
}
