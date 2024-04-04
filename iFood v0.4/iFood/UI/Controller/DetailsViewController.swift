import UIKit

class DetailsViewController: UIViewController, Storyboarded {
    
    weak var coordinator: SubmenuCoordinator?
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeDescription: UILabel!
    @IBOutlet weak var recipeTitle: UILabel!
    
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        guard let safe = recipe else { return}
        recipeImage.image = UIImage(named: safe.imageName)
        recipeTitle.text = safe.title
        recipeDescription.text = safe.instructions
    }
}
