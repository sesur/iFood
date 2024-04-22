import UIKit

class MenuDelegate: NSObject {

    private let items: [MenuItemViewModel]
    
    init(tableView: UITableView?, items: [MenuItemViewModel]) {
        self.items = items
        super.init()
        tableView?.delegate = self
    }
}

extension MenuDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.select(indexPath.row)
    }
}
