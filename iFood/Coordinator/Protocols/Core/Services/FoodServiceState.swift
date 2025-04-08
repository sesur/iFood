import UIKit

protocol FoodCategoryProtocol {
    func retrieveCategories(completion: @escaping(FoodServiceComposer.ServiceResult) -> Void)
}

protocol FoodRecipeProtocol {
    func retrieveRecipes(completion: @escaping(FoodServiceComposer.ServiceResult) -> Void)
}

class FoodServiceState: FoodCategoryProtocol, FoodRecipeProtocol {
 
    private let service: FoodServiceComposer
    
    init(service: FoodServiceComposer) {
        self.service = service
    }
    
    func retrieveCategories(completion: @escaping(FoodServiceComposer.ServiceResult) -> Void) {
        service.getFood(completion: completion)
    }
    
    func retrieveRecipes(completion: @escaping(FoodServiceComposer.ServiceResult) -> Void) {
        service.getFood(completion: completion)
    }
}
