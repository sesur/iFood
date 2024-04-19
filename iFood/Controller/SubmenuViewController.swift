import UIKit
import SwiftUI

struct ItemProperties {
    let id: Int
    let recipe: Recipe?
    var submenuAction: ((ItemProperties) -> Void)?
    
    init(id: Int,
         recipe: Recipe? = nil,
         submenuAction: ((ItemProperties) -> Void)? = nil) {
        self.id = id
        self.recipe = recipe
        self.submenuAction = submenuAction
    }
}

class SubmenuViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    var itemProperties: ItemProperties?
    var recipes = [Recipe]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
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
        guard let properties = itemProperties else { return }
        let item = ItemProperties(id: properties.id, recipe: recipe)
        properties.submenuAction?(item)
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
