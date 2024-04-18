import UIKit

class FoodServiceState {

    public enum Result {
         case success(Food)
         case failure(Error)
     }
    
    func loadCategories(completion: @escaping (Result) -> Void) {
        FoodService().fetchFood { result in
            switch result {
            case .success(let food):
                completion(.success(food))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
