import UIKit

class MainCoordinator: NSObject, Coordinator, MenuProtocol, UINavigationControllerDelegate {
    
    var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let state: FoodServiceState
    
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

        let items = state.service.getCategories().map { category in
            MenuItemViewModel(id: nil,
                              title: category.title,
                              imageName: category.imageName,
                              select: { [weak self] id in
                self?.showMenu(id: id)
            })
        }
        
        menuViewController.items = items
        
        navigationController.pushViewController(menuViewController, animated: true)
    }
    
    //MARK:- MenuProtocol
    func showMenu(id: Int) {
        let child = SubmenuCoordinator(navigationController: navigationController,
                                       state: self.state,
                                       categoryId: id)
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

struct MenuItemViewModel {
    let id: Int?
    let title: String
    let imageName: String
    let select: (Int) -> Void
}
