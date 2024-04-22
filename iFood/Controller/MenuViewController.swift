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
        let loadingController = LoadingViewController()
        add(loadingController)
        
        updateMenu(
            with: items,
            tableView: self.tableview,
            loadingController: loadingController
        )
    }
    
    private func updateMenu(
        with items: [MenuItemViewModel],
        tableView: UITableView,
        loadingController: LoadingViewController
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            loadingController.remove()

            if !items.isEmpty {
                self?.dataSource = MenuDataSource(items: items)
                self?.delegate = MenuDelegate(tableView: tableView, items: items)
            }
        }
    }
}

extension UIViewController {
    
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove(){
        guard parent != nil  else { return }
        willMove(toParent: parent)
        view.removeFromSuperview()
        removeFromParent()
    }
}

class LoadingViewController: UIViewController {
    
    lazy var activityIndicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .lightGray
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSpinner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
    
    func addSpinner() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        // Center our spinner both horizontally & vertically
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
