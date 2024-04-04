import Foundation

protocol MenuProtocol {
    func showSubmenu(_ tittle: String)
    func showDetails(_ recipe: Recipe?)
    func removeDidFinish(_ child: Coordinator?)
}

extension MenuProtocol {
    func showDetails(_ recipe: Recipe?) {
        
    }
}
