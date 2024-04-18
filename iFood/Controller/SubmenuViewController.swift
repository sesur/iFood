import UIKit
import SwiftUI

class SubmenuViewController: UIViewController, Storyboarded {
    
    var state: FoodServiceState?
    weak var coordinator: MainCoordinator?
    var id: Int?
    var food: Food?
    var recipes = [Recipe]()
    var submenuAction: ((Recipe?) -> Void)?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        guard let categoryId = self.id,
            let recipes = getRecipes(by: categoryId) else { return }
        self.recipes = recipes
        
    }
    
    private func getRecipes(by id: Int) -> [Recipe]? {
        guard let recipes = state?.retrieveRecipes() else { return nil }
        
        let filteredRecipes = recipes.filter({ $0.id == id })
        return filteredRecipes
    }
}

extension SubmenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = recipes[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "submenuCell",
                                                            for: indexPath) as? SubmenuCell
        else {
            return UICollectionViewCell()
        }

        cell.contentConfiguration = UIHostingConfiguration {
            let viewModel = RecipeViewModel(title: item.title,
                                            instructions: item.instructions,
                                            imageName: item.imageName)
            SubmenuView(viewModel: viewModel)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellDimention = (width / 2) - 0
        return CGSize(width: cellDimention, height: cellDimention)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.item]
        submenuAction?(recipe)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

struct RecipeViewModel {
    let title: String
    let instructions: String
    let imageName: String
}
