import UIKit
import SwiftUI

class SubmenuCoordinator: NSObject, Coordinator, MenuProtocol, UINavigationControllerDelegate {

    weak var parentCoordinator: MainCoordinator?
    var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    
    let categoryId: Int
    let state: FoodServiceState
    
    init(navigationController: UINavigationController,
         state: FoodServiceState,
         categoryId: Int) {
        self.navigationController = navigationController
        self.state = state
        self.categoryId = categoryId
    }
    
    func start() {
        navigationController.delegate = self
        showCategoryMenu()
    }
    
    //MARK:- MenuProtocol
    func showCategoryMenu() {
        let submenuViewCntroller = SubmenuViewController.instantiate()
        submenuViewCntroller.state = self.state
        submenuViewCntroller.id = self.categoryId
        submenuViewCntroller.submenuAction = { [weak self] recipe in
            self?.showDetails(recipe)
        }
        
        navigationController.pushViewController(submenuViewCntroller, animated: true)
    }
    
    func removeDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinator.enumerated() {
            if child === coordinator {
                childCoordinator.remove(at: index)
                break
            }
        }
    }
    
    //ShowDetailsViewController
    func showDetails(_ recipe: Recipe?) {
        guard let recipe = recipe else { return }
        let itemDetailsView = ItemDetailsView(recipe: recipe)
        let itemHostingView = UIHostingController(rootView: itemDetailsView)
        navigationController.pushViewController(itemHostingView, animated: true)
    }
    
    //MARK:- UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {return}
        if navigationController.viewControllers.contains(fromViewController) {return}
        
//        if let detailsViewController = fromViewController as? DetailsViewController {
//            removeDidFinish(detailsViewController.coordinator)
//        }
    }
    
}
