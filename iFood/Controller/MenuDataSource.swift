import UIKit

class MenuDataSource: NSObject, UITableViewDataSource {
    
    private let categories: [CategoryViewModel]
    private let reuseIdentifier = "cellCategory"
    
    init(categories: [CategoryViewModel]) {
        self.categories = categories
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
        cell.configure(item)
        return cell
    }
}
