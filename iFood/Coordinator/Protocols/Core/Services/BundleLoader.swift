import Foundation

protocol BundleProtocol {
    func url(forResource name: String?, withExtension ext: String?) -> URL?
}

class BundleLoader: BundleProtocol {
    func url(forResource name: String?, withExtension ext: String?) -> URL? {
        guard let name, !name.isEmpty,
              let ext, !ext.isEmpty,
              ext == "json" else {
            return nil
        }
        return Bundle.main.url(forResource: name, withExtension: ext)
    }
}
