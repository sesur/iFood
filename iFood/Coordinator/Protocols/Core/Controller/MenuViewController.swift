import UIKit

class MenuViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableview: UITableView!
    
    var items: [MenuItemViewModel]?
    
    var dataSource: UITableViewDataSource? {
        didSet {
            tableview.dataSource = dataSource
            tableview.reloadData()
        }
    }
    
    var delegate: UITableViewDelegate? {
        didSet {
            tableview.delegate = delegate
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items {
            load(items: items)
        }
    }
    
    private func load(items: [MenuItemViewModel]) {
        let spiner = SpinnerViewController()
        add(spiner)
        
        updateMenu(
            with: items,
            tableView: self.tableview,
            spiner: spiner
        )
    }
    
    private func updateMenu(
        with items: [MenuItemViewModel],
        tableView: UITableView,
        spiner: SpinnerViewController
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            spiner.remove()

            if !items.isEmpty {
                self?.dataSource = MenuDataSource(items: items)
                self?.delegate = MenuDelegate(tableView: tableView, items: items)
            }
        }
    }
}
