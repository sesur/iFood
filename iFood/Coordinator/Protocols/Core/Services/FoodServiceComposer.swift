import Foundation

enum FoodServiceError: Error {
    case fileNotFound
    case dataCorruption
}

typealias FeedResult = Result<Food, FoodServiceError>

protocol FeedLoader {
    @available(*, deprecated, message: "Use async `getResults()` instead.")
    func get(completion: @escaping(FeedResult) -> Void)
    func getResults() async -> FeedResult
}

extension FeedLoader {
    func getResults() -> FeedResult {
        .failure(.fileNotFound)
    }
    
    func get(completion: @escaping(FeedResult) -> Void) {
        
    }
}

struct RemoteLoader: FeedLoader {
    
    func get(completion: @escaping(FeedResult) -> Void) {
        // TODO: create data from remote
    }
}

enum FileName: String {
    case food
    case corrupted
    case unknown
    case empty = ""
}

enum FileExtensionType: String {
    case json
    case txt
    case unknown
    case empty = ""
}

struct BundleResources {
    let fileName: FileName?
    let fileExtension: FileExtensionType?
    
    
    
    init(fileName: FileName?, fileExtension: FileExtensionType?) {
        self.fileName = fileName
        self.fileExtension = fileExtension
    }
}

struct LocalLoader: FeedLoader {
    let loader: BundleLoaderProtocol
    let bundle: BundleResources
    
    func getResults() async -> FeedResult {
        guard let path = loader.url(resources: bundle) else {
            return .failure(.fileNotFound)
        }
        
        do {
            let jsonData = try Data(contentsOf: path)
            let food = try JSONDecoder().decode(Food.self, from: jsonData)
            return .success(food)
        } catch {
            return .failure(.dataCorruption)
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
        switch localLoader.getResults() {
        case .success(let food): completion(.success(food.categories))
        case .failure(let error): completion(.failure(error))
        }
    }
        
    func getCategoriesWithAsync(completion: @escaping (ServiceResult) -> Void) {
        Task {
            let result = await localLoader.getResults()
            
            switch result {
            case .success(let food):
                completion(.success(food.categories))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getRecipes() -> [Recipe] {
        let result = localLoader.getResults()
        handleFeedResult(result)
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
