import UIKit

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
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
        displayMenu()
    }
    
    private func displayMenu() {
        let menuViewController = MenuViewController.instantiate()
        
        let items = state.service.getCategories().map { category in
            MenuItemViewModel(id: nil,
                              title: category.title,
                              imageName: category.imageName,
                              select: { [weak self] id in
                self?.startSubmenuCoordinator(with: id)
            })
        }
        
        menuViewController.items = items
        navigationController.pushViewController(menuViewController, animated: true)
    }
    
    private func startSubmenuCoordinator(with categoryId: Int) {
        let child = SubmenuCoordinator(navigationController: navigationController,
                                       state: self.state,
                                       categoryId: categoryId)
        childCoordinator = [child]
        child.parentCoordinator = self
        child.start()
    }
    
    private func removeDidFinish(_ child: Coordinator?) {
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
