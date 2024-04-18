import UIKit
import SwiftUI

class SubmenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    var id: Int?
    var food: Food?
    var submenuArray: [Recipe]?
    var submenuAction: ((Recipe?) -> Void)?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        submenuArray = getSubmenu(id ?? 0)
    }
    
    private func getSubmenu(_ id: Int) -> [Recipe] {
        let state = StateController()
        state.loadCategories { [weak self] result in
            switch result {
            case .success(let food):
                self?.food = food
            case .failure(let error):
                print(error)
            }
        }
    
        let recipes = food?.recipes.compactMap { item in
            if item.id == id  {
                return item
            }
            return nil
        }
        
        return recipes ?? []
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return submenuArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = submenuArray?[indexPath.item],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "submenuCell",
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
        let recipe = submenuArray?[indexPath.item]
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
