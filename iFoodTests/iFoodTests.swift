
import Testing
@testable import iFood
import Foundation

struct LocalLoaderTests {

    @Test func initSUT() {
        let bundleMock = BundleLoader()
        let sut = LocalLoader(bundle: bundleMock, fileName: "")
            
        var feedResults: FeedResult?
        
        sut.get { results in
            feedResults = results
        }
        
        #expect(feedResults != nil)
    }
    
    @Test func bundleFileDoesNotExists() async {
        let bundleMock = BundleLoader()
//        bundleMock.shouldReturnValidPath = false
        
        let sut = LocalLoader(bundle: bundleMock, fileName: BundleFileName.unknown)
        #expect(sut != nil)
        
        await confirmation("confirmation") { expectation in
                  sut.get { result in
                      switch result {
                      case .success:
                          #expect(result != nil)
                          
                      case .failure(let error):
                          expectation()
                      }
                  }
              }

    }

}

class BundleMock: BundleProtocol {
    var shouldReturnValidPath = true
    var resourceFileName: String?
    
    func url(forResource name: String?, withExtension ext: String?) -> URL? {
        if shouldReturnValidPath, let resourceFileName = resourceFileName, name == resourceFileName, ext == "json" {
            // Return a dummy URL, simulating a valid path
            return URL(fileURLWithPath: "/path/to/\(resourceFileName).\(ext ?? "")")
        }
        // Simulate file not found by returning nil
        return nil
    }
}
