import Testing
import Foundation
@testable import iFood

struct BundleLoaderTests {
    
    @Test("Should return invalid Bundle URL path for 'invalid' resources")
    func urlForResources_shouldReturnNil() {
        var url = makeSUT()
        #expect(url == nil)
        
        url = makeSUT(fileName: .empty, fileExtension: .empty)
        #expect(url == nil)
        
        url = makeSUT(fileName: .empty, fileExtension: .json)
        #expect(url == nil)
        
        url = makeSUT(fileName: .food, fileExtension: .txt)
        #expect(url == nil)
        
        url = makeSUT(fileName: .unknown, fileExtension: .json)
        #expect(url == nil)
        
        url = makeSUT(fileName: .unknown, fileExtension: .unknown)
        #expect(url == nil)
    }
    
    @Test("Should return valid Bundle URL path for 'valid' resources")
    func urlForResources_shouldReturnURL() {
        let url = makeSUT(fileName: .food, fileExtension: .json)
        #expect(url != nil)
        #expect(url?.pathExtension == "json")
        #expect(url?.isFileURL == true)
        #expect(url?.lastPathComponent == "Food.json")
    }
    
    private func makeSUT(fileName: FileName? = nil, fileExtension: FileExtensionType? = nil) -> URL? {
        let bundleResources = BundleResources(fileName: fileName,
                                              fileExtension: fileExtension)
        let sut = BundleLoader()
        return sut.url(resources: bundleResources)
    }
}
