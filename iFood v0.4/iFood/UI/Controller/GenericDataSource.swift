//
//  MenuDataSource.swift
//  iFood
//
//  Created by Sergiu on 8/6/19.
//  Copyright © 2019 Sergiu. All rights reserved.
//

import UIKit

class GenericDataSource<T>: NSObject, UITableViewDataSource {
    
    let menu: [FoodCategory]
    typealias CellConfigurator = (FoodCategory, UITableViewCell) -> Void

    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator

    init(menu: [FoodCategory], reuseIdentifier: String,  cellConfigurator: @escaping CellConfigurator) {
        self.menu = menu
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menu = self.menu[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cellConfigurator(menu, cell)
        return cell
    }
}

extension GenericDataSource where T == FoodCategory {
    static func make(for menu: [FoodCategory], reuseIdentifier: String = "cellCategory") -> GenericDataSource {
        return GenericDataSource(menu: menu, reuseIdentifier: reuseIdentifier) { (menu, cell) in
            let cell = cell as! CategoryCell
            cell.wrapperCell = menu
        }
    }
}
