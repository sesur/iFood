import UIKit

class MenuDelegate: NSObject {

    private let viewModel: [CategoryViewModel]
    
    init(tableView: UITableView?, viewModel: [CategoryViewModel]) {
        self.viewModel = viewModel
        super.init()
        tableView?.delegate = self
    }
}

extension MenuDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel[indexPath.row]
        item.select()
    }
}
