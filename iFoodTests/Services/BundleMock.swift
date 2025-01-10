import Foundation
@testable import iFood

class BundleMock: BundleLoaderProtocol {
    func url(resources bundle: BundleResources) -> URL? {
        let name = bundle.fileName?.rawValue.capitalized
        let ext = bundle.fileExtension?.rawValue
        
        if let name, let ext {
            return Bundle.main.url(forResource: name, withExtension: ext)
        }
        return nil
    }
}
