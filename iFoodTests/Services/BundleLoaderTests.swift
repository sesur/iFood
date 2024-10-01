import Testing
import Foundation
@testable import iFood

struct BundleLoaderTests {
    private struct FileName {
        static let empty = ""
        static let valid = "Food"
        static let invalid = "Invalid"
        static let validExtension = "json"
        static let invalidExtension = "txt"
    }
    
    @Test("Bundle URL path with Invalid resources should return nil")
    func urlForResources_shouldReturnNil() {
        var url = makeSUT(fileName: nil, ext: nil)
        #expect(url == nil)
        
        url = makeSUT(fileName: FileName.empty, ext: FileName.empty)
        #expect(url == nil)
        
        url = makeSUT(fileName: FileName.empty, ext: FileName.validExtension)
        #expect(url == nil)
        
        url = makeSUT(fileName: FileName.valid, ext: FileName.invalidExtension)
        #expect(url == nil)
        
        url = makeSUT(fileName: FileName.invalid, ext: FileName.validExtension)
        #expect(url == nil)
        
        url = makeSUT(fileName: FileName.invalid, ext: FileName.validExtension)
        #expect(url == nil)
    }
    
    @Test("Bundle URL path with Valid resources should return valid URL")
    func urlForResources_shouldReturnURL() {
        let url = makeSUT(fileName: FileName.valid, ext: FileName.validExtension)
        #expect(url != nil)
        #expect(url?.pathExtension == "json")
        #expect(url?.isFileURL == true)
        #expect(url?.lastPathComponent == "Food.json")
    }
    
    private func makeSUT(fileName: String? = nil, ext: String? = FileName.valid) -> URL? {
        let sut = BundleLoader()
        return sut.url(forResource: fileName, withExtension: ext)
    }
}
