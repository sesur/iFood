import UIKit

class MenuDelegate: NSObject {

    private let menu: [CategoryViewModel]
    
    init(tableView: UITableView?, menu: [CategoryViewModel]) {
        self.menu = menu    
        super.init()
        tableView?.delegate = self
    }
}

extension MenuDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = menu[indexPath.row]
        item.select()
    }
}
