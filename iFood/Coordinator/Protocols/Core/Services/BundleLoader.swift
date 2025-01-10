import Foundation

protocol BundleLoaderProtocol {
    func url(resources bundle: BundleResources) -> URL?
}

class BundleLoader: BundleLoaderProtocol {
    func url(resources bundle: BundleResources) -> URL? {
        
        guard let fileName = bundle.fileName?.rawValue.capitalized, !fileName.isEmpty,
              let fileExtension = bundle.fileExtension, !fileExtension.rawValue.isEmpty,
              fileExtension == .json else {
            return nil
        }
        
        return Bundle.main
            .url(
                forResource: fileName,
                withExtension: fileExtension.rawValue
            )
    }
}
