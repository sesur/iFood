import UIKit

class MainCoordinator: NSObject, Coordinator, MenuProtocol, UINavigationControllerDelegate {
    
    var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let state: FoodServiceState
    private var categoryId: Int?
    
    init(navigationController: UINavigationController,
         state: FoodServiceState) {
        self.navigationController = navigationController
        self.state = state
    }
    
    func start() {
        navigationController.delegate = self
        showMenuViewController()
    }
    
    fileprivate func showMenuViewController() {
        let menuViewController = MenuViewController.instantiate()
        menuViewController.state = self.state
        menuViewController.cellAction = { [weak self] categoryId in
            self?.categoryId = categoryId
            self?.showCategoryMenu()
        }
        navigationController.pushViewController(menuViewController, animated: true)
    }
    
    //MARK:- MenuProtocol
    func showCategoryMenu() {
        guard let categoryId = self.categoryId else { return }
        let child = SubmenuCoordinator(navigationController: navigationController,
                                       state: self.state,
                                       categoryId: categoryId)
        childCoordinator = [child]
        child.parentCoordinator = self
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
