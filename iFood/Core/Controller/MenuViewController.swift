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
//        if let items {
//            load(items: items)
//        }
        
        // Example usage:
        let nums = [2, 7, 11, 15]
        let target = 9
        print(twoSum(nums, target))
        
    }
    
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var numToIndex: [Int: Int] = [:]
        
        for (index, num) in nums.enumerated() {
            if let complementIndex = numToIndex[target - num] {
                return [complementIndex, index]
            }
            numToIndex[num] = index
        }
        
        return []
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
