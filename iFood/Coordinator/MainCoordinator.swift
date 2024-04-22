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

        let categories = state.service.getCategories().map { category in
            MenuItemViewModel(title: category.title,
                              imageName: category.imageName,
                              select: { [weak self] id in
                self?.showMenu(id: id)
            })
        }
        
        let properties = MenuProperties()
        let viewModel = MenuViewModel(properties: properties,
                                      categories: categories)
        
        menuViewController.viewModel = viewModel
        
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

struct MenuViewModel {
    var properties: MenuProperties
    let categories: [MenuItemViewModel]
}

struct MenuProperties {
    var id: Int?
    var submenuAction: ((MenuItemViewModel) -> Void)?
    
    init(id: Int? = nil,
         submenuAction: ((MenuItemViewModel) -> Void)? = nil) {
        self.id = id
        self.submenuAction = submenuAction
    }
}

struct MenuItemViewModel {
    let title: String
    let imageName: String
    let select: (Int) -> Void
}
