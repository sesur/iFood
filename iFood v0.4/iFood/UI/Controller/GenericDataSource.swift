//
//  MenuDataSource.swift
//  iFood
//
//  Created by Sergiu on 8/6/19.
//  Copyright © 2019 Sergiu. All rights reserved.
//

import UIKit

class GenericDataSource: NSObject, UITableViewDataSource {
    
    let menu: [FoodCategory]
    private let reuseIdentifier: String

    init(menu: [FoodCategory], reuseIdentifier: String) {
        self.menu = menu
        self.reuseIdentifier = reuseIdentifier
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menu = self.menu[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
        
        let vm = CategoryViewModel(menu) { }
        vm.select()
        cell.configure(vm)
        return cell
    }
}

extension GenericDataSource {
    static func make(for menu: [FoodCategory], reuseIdentifier: String = "cellCategory") -> GenericDataSource {
        return GenericDataSource(menu: menu, reuseIdentifier: reuseIdentifier)
    }
}
