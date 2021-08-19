//
//  CategoryCell.swift
//  iFood
//
//  Created by Sergiu on 3/5/19.
//  Copyright © 2019 Sergiu. All rights reserved.
//

import UIKit
class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    func configure(_ vm: CategoryViewModel) {
        categoryImage.image = UIImage(named: vm.image)
        categoryTitle.text = vm.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImage.layer.cornerRadius = 10
    }
}

struct CategoryViewModel {
    let image: String
    let title: String
    let select: () -> Void
}

extension CategoryViewModel {
    init(_ category: FoodCategory, selection: @escaping () -> Void) {
        image = category.imageName
        title = category.title.rawValue
        select = selection
    }
}
