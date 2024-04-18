import UIKit

class MainCoordinator: NSObject, Coordinator, MenuProtocol, UINavigationControllerDelegate {
    
    var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        showMenuViewController()
    }
    
    fileprivate func showMenuViewController() {
        let menuViewController = MenuViewController.instantiate()
        menuViewController.cellAction = { [weak self] id in
            self?.showSubmenu(id)
        }
        navigationController.pushViewController(menuViewController, animated: true)
    }
    
    //MARK:- MenuProtocol
    func showSubmenu(_ id: Int) {
        let child = SubmenuCoordinator(navigationController: navigationController)
        childCoordinator.append(child)
        child.parentCoordinator = self
        child.id = id
        child.start()
    }
    
    func removeDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinator.enumerated() {
            if coordinator === child {
                childCoordinator.remove(at: index)
                break
            }
        }
    }
    
    //MARK:- UInavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {return}
        if navigationController.viewControllers.contains(fromViewController) {return}
        
        if let menuViewController = fromViewController as? SubmenuViewController {
            removeDidFinish(menuViewController.coordinator)
        }
    }
}
