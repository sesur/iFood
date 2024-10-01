
import Testing
@testable import iFood
import Foundation

@Suite
struct LocalLoaderTests {
    
    @Test("Feed results from nil fileName & fileExtension, should return '.fileNotFound'")
    func loadFeedResultWithNilValues() async {
        let result = await loadFeedResult(from: makeSUT())
        
        switch result {
        case .success(let food):
            #expect(food.categories.count == 3)
        case .failure(let error):
            #expect(error == .fileNotFound)
        case .none:
            Issue.record("Expected feed result, but received nil.")
        }
    }
    
    @Test("Feed results from Wrong file name, should return '.fileNotFound'")
    func loadFeedResultFromNotExistingFile() async {
        
        let sut = makeSUT(fileName: "DoesNotExist", fileExtension: "json")
        let result = await loadFeedResult(from: sut)
        
        switch result {
        case .success(let food):
            #expect(food.categories.count == 3)
        case .failure(let error):
            #expect(error == .fileNotFound)
        case .none:
            Issue.record("Expected feed result, but received nil.")
        }
    }
    
    @Test("Feed results from Wrong file extwnsion, should return '.fileNotFound'")
    func loadFeedResultFromWrongFileExtension() async {
        
        let sut = makeSUT(fileName: "Food", fileExtension: "txt")
        let result = await loadFeedResult(from: sut)
        
        switch result {
        case .success(let food):
            #expect(food.categories.count == 3)
        case .failure(let error):
            #expect(error == .fileNotFound)
        case .none:
            Issue.record("Expected feed result, but received nil.")
        }
    }
    
    @Test("Feed results from correct file name, should return items")
    func loadFeedResultFromCorrectFile() async throws {
        let sut = makeSUT(fileName: "Food", fileExtension: "json")
        let result = await loadFeedResult(from: sut)
        
        switch result {
        case .success(let food):
            #expect(food.categories.count == 5)
            #expect(food.categories.first?.title == "Burgers")
            #expect(food.categories.last?.title == "Sandwiches")
        case .failure(let error):
            #expect(error == .fileNotFound)
        case .none:
            Issue.record("Expected feed result, but received nil.")
        }
        
        #expect(sut.fileName == "Food")
        #expect(sut.ext == "json")
    }
    
    @Test("Feed results from corrupted file name, should return '.dataCorruption'")
    func loadFeedResultFromCorruptedFile() async throws {
        let sut = makeSUT(fileName: "FoodCorrupted", fileExtension: "json")
        let result = await loadFeedResult(from: sut)
        
        switch result {
        case .success(let food):
            #expect(food.categories.count == 1)
        case .failure(let error):
            #expect(error == .dataCorruption)
        case .none:
            Issue.record("Expected feed result, but received nil.")
        }
        
        #expect(sut.fileName == "FoodCorrupted")
        #expect(sut.ext == "json")
    }
    
    //MARK: - Helpers
    private func makeSUT(fileName: String? = nil, fileExtension: String? = nil) -> LocalLoader {
        let sut = LocalLoader(bundle: BundleMock(),
                              fileName: fileName,
                              ext: fileExtension)
        return sut
    }
    
    private func loadFeedResult(from sut: LocalLoader) async -> FeedResult? {
        var result: FeedResult?
        
        await confirmation { fulfil in
            sut.get { loadResult in
                result = loadResult
                fulfil()
            }
        }
        return result
    }
}
