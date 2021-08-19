//
//  MenuDataSource.swift
//  iFood
//
//  Created by Sergiu on 8/6/19.
//  Copyright © 2019 Sergiu. All rights reserved.
//

import UIKit

class DataSource: NSObject, UITableViewDataSource {
    
    private let menu: [CategoryViewModel]
    private let reuseIdentifier = "cellCategory"
    
    init(menu: [CategoryViewModel]) {
        self.menu = menu
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.menu[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
        cell.configure(item)
        item.select()
        return cell
    }
}
