import Foundation

enum FoodServiceError: Error {
    case fileNotFound
    case dataCorruption
}

typealias FeedResult = Result<Food, FoodServiceError>

protocol FeedLoader {
    func get(completion: @escaping(FeedResult) -> Void)
}

struct RemoteLoader: FeedLoader {
    
    func get(completion: @escaping(FeedResult) -> Void) {
        // TODO: create data from remote
    }
}

struct BundleFileName {
    static let food = "Food"
    static let unknown = "unknown"
}

struct LocalLoader: FeedLoader {
    let bundle: BundleProtocol
    let fileName: String?
    let ext: String?
    
    func get(completion: @escaping(FeedResult) -> Void) {
        guard let path = bundle.url(forResource: fileName, withExtension: ext) else {
            completion(.failure(.fileNotFound))
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: path)
            let food = try JSONDecoder().decode(Food.self, from: jsonData)
            completion(.success(food))
        } catch {
            completion(.failure(.dataCorruption))
        }
    }
}

final class FoodServiceComposer {
    
    let remoteLoader: FeedLoader
    let localLoader: FeedLoader
    
    private var recipes = [Recipe]()
    
    enum ServiceResult: Error {
        case success([FoodCategory])
        case failure(Error)
    }
    
    init(remoteLoader: FeedLoader,
         localLoader: FeedLoader) {
        self.remoteLoader = remoteLoader
        self.localLoader = localLoader
    }
    
    func getCategories(completion: @escaping (ServiceResult) -> Void) {
        localLoader.get { result in
            switch result {
            case .success(let food):
                completion(.success(food.categories))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
            self.recipes = food.recipes
        case .failure(let error):
            print(error)
            self.recipes = []
        }
    }
}
