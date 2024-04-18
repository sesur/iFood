import UIKit
import SwiftUI

class SubmenuCoordinator: NSObject, Coordinator, MenuProtocol {

    weak var parentCoordinator: MainCoordinator?
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
     
    //ShowDetailsViewController
    func showDetails(_ recipe: Recipe?) {
        guard let recipe = recipe else { return }
        let itemDetailsView = ItemDetailsView(recipe: recipe)
        let itemHostingView = UIHostingController(rootView: itemDetailsView)
        navigationController.pushViewController(itemHostingView, animated: true)
    }
}
