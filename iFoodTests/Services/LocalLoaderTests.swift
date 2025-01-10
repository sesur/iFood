
import Testing
@testable import iFood
import Foundation

@Suite
struct LocalLoaderTests {
    
    @Test("Feed results for invalid file resources should return '.fileNotFound'")
    func loadFeedResultWithNilValues() async {
        
        var sut = makeSUT()
        var result = await loadFeedResult(from: makeSUT())
        
        #expect(result.error == .fileNotFound)
        
        sut = makeSUT(fileName: .unknown,
                      fileExtension: .json)
        result = await loadFeedResult(from: sut)
        
        #expect(result.error == .fileNotFound)
        
        sut = makeSUT(fileName: .food, fileExtension: .txt)
        result = await loadFeedResult(from: sut)
        
        #expect(result.error == .fileNotFound)
        
        sut = makeSUT(fileName: .unknown, fileExtension: .unknown)
        result = await loadFeedResult(from: sut)
        
        #expect(result.error == .fileNotFound)
    }
    
    @Test("Feed results for valid file resources, should return items")
    func loadFeedResultFromCorrectFile() async {
        let sut = makeSUT(fileName: .food, fileExtension: .json)
        let result = await loadFeedResult(from: sut)
        
        #expect(result.food?.categories.count == 5)
        #expect(result.food?.categories.first?.title == "Burgers")
        #expect(result.food?.categories.last?.title == "Sandwiches")
        #expect(sut.bundle.fileName?.rawValue == FileName.food.rawValue)
        #expect(sut.bundle.fileExtension?.rawValue == FileExtensionType.json.rawValue)
    }
    
    @Test("Feed results from corrupted file resources, should return '.dataCorruption'")
    func loadFeedResultFromCorruptedFile() async {
        let sut = makeSUT(fileName: .corrupted, fileExtension: .json)
        let result = await loadFeedResult(from: sut)
        
        #expect(result.error == .dataCorruption)
        #expect(sut.bundle.fileName?.rawValue == FileName.corrupted.rawValue)
        #expect(sut.bundle.fileExtension?.rawValue == FileExtensionType.json.rawValue)
    }
    
    //MARK: - Helpers
    private func makeSUT(fileName: FileName? = nil, fileExtension: FileExtensionType? = nil) -> LocalLoader {
        let bundleResources = BundleResources(fileName: fileName,
                                              fileExtension: fileExtension)
        return LocalLoader(loader: BundleMock(),
                           bundle: bundleResources)
    }
    
    private func loadFeedResult(from sut: LocalLoader) async -> (food: Food?, error: FoodServiceError?) {
        let result = await sut.getResults()
        
        switch result {
        case .success(let food):
            return (food, nil)
        case .failure(let error):
            return (nil, error)
        }
    }
}
