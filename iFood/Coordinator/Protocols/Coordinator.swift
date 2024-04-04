import UIKit

protocol Coordinator: AnyObject {
    var childCoordinator: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    
    func start()
}
