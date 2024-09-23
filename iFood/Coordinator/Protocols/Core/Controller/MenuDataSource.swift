import UIKit

class MenuDataSource: NSObject, UITableViewDataSource {
    
    private let items: [MenuItemViewModel]
    private let reuseIdentifier = "cellCategory"
    
    init(items: [MenuItemViewModel]) {
        self.items = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard !items.isEmpty,
              let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CategoryCell else
        {
            return UITableViewCell()
        }
        
        let item = self.items[indexPath.row]
        cell.configure(item)
        
        return cell
    }
}
