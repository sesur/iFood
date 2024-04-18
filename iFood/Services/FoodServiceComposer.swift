import Foundation

enum FoodServiceError: Error {
    case fileNotFound
}

typealias FeedResult = Result<Food, Error>

protocol FeedLoader {
    func get(completion: @escaping(FeedResult) -> Void)
}

struct RemoteLoader: FeedLoader {
    
    func get(completion: @escaping(FeedResult) -> Void) {
        // TODO: create data from remote
    }
}

struct LocalLoader: FeedLoader {
    func get(completion: @escaping(FeedResult) -> Void) {
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

final class FoodServiceComposer {
    
    let remoteLoader: FeedLoader
    let localLoader: FeedLoader
    
    private var categories = [FoodCategory]()
    private var recipes = [Recipe]()
    
    init(remoteLoader: FeedLoader,
         localLoader: FeedLoader) {
        self.remoteLoader = remoteLoader
        self.localLoader = localLoader
    }
    
    func getCategories() -> [FoodCategory] {
        localLoader.get { [weak self] result in
            self?.handleFeedResult(result)
        }
        
        return categories
    }
    
    func getRecipes() -> [Recipe] {
        localLoader.get { [weak self] result in
            self?.handleFeedResult(result)
        }
        
        return recipes
    }
    
    private func handleFeedResult(_ result: FeedResult) {
        switch result {
        case .success(let food):
            self.categories = food.categories
            self.recipes = food.recipes
        case .failure(let error):
            print(error)
            self.categories = []
            self.recipes = []
        }
    }
}
