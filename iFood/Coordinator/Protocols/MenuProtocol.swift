import Foundation

protocol MenuProtocol {
    func showCategoryMenu()
    func showDetails(_ recipe: Recipe?)
    func removeDidFinish(_ child: Coordinator?)
}

extension MenuProtocol {
    func showDetails(_ recipe: Recipe?) {
        
    }
}
