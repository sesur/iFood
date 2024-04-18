import Foundation

enum FoodServiceError: Error {
    case fileNotFound
}

final class FoodService {
    
    func fetchFood(completion: @escaping(Result<Food, Error>) -> Void) {
        guard let path = Bundle.main.url(forResource: "Food", withExtension: "json") else {
            completion(.failure(FoodServiceError.fileNotFound))
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: path)
            let food = try JSONDecoder().decode(Food.self, from: jsonData)
            completion(.success(food))
        } catch {
            completion(.failure(error))
        }
    }
}
