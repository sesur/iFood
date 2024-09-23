import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    func configure(_ viewModel: MenuItemViewModel) {
        categoryImage.image = UIImage(named: viewModel.imageName)
        categoryTitle.text = viewModel.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImage.layer.cornerRadius = 10
    }
}
