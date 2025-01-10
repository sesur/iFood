import UIKit
import SwiftUI

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
        retrieveCategories()
    }
    
    private func retrieveCategories() {
        state.retrieveCategories { [weak self] result in
            switch result {
            case .success(let items):
                let fetchItems = items.map { item in
                    MenuItemViewModel(id: item.id,
                                      title: item.title,
                                      imageName: item.imageName,
                                      select: { [weak self] selectionId in
                        self?.startSubmenuCoordinator(with: selectionId)
                    })
                }
                Task {
                    self?.displayMenu(items: fetchItems)
                }
                
            case .failure(let error):
                debugPrint("error: \(error.localizedDescription)")
            }
        }
    }
    
    private func displayMenu(items: [MenuItemViewModel]) {
        let menuViewController = MenuViewController.instantiate()
        menuViewController.items = items
        navigationController.pushViewController(menuViewController, animated: true)
    }
    
    private func startSubmenuCoordinator(with categoryId: Int) {
        let child = SubmenuCoordinator(navigationController: navigationController,
                                       state: self.state,
                                       categoryId: categoryId)
        childCoordinator.append(child)
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
    
    //MARK: - UInavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        if navigationController.viewControllers.contains(fromViewController) { return }
        
        if let hostingController = fromViewController as? UIHostingController<ItemView> {
            removeDidFinish(hostingController.rootView.coordinator)
        }
    }
}

struct MenuItemViewModel {
    let id: Int?
    let title: String
    let imageName: String
    let select: (Int) -> Void
}
