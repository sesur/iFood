import Foundation
@testable import iFood

class BundleMock: BundleProtocol {
    func url(forResource name: String?, withExtension ext: String?) -> URL? {
        if let name, let ext {
            return Bundle.main.url(forResource: name, withExtension: ext)
        }
        return nil
    }
}
