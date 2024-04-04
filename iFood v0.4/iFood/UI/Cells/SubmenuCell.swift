import UIKit

class SubmenuCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    var wrapperCell: Recipe? {
        didSet {
            guard let safeData = wrapperCell else {return}
            categoryImage.image = UIImage(named: safeData.imageName)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImage.layer.cornerRadius = 10
    }
}
