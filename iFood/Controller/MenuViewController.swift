import UIKit

class MenuViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableview: UITableView!
    
    var cellAction: ((Int) -> Void)?
    var state: FoodServiceState?
    
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
    
    var food: Food?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let categories = state?.retrieveCategories() {
            load(categories: categories)
        }
    }
    
    private func load(categories: [FoodCategory]) {
        let loadingController = LoadingViewController()
        add(loadingController)
        
        updateMenu(
            with: categories,
            tableView: self.tableview,
            loadingController: loadingController
        )
    }
    
    private func updateMenu(
        with categories: [FoodCategory],
        tableView: UITableView,
        loadingController: LoadingViewController
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            loadingController.remove()
            
            let menuCategories = categories.compactMap { item in
                CategoryViewModel(image: item.imageName,
                                  title: item.title,
                                  select: {  })
            }
            
            self?.dataSource = MenuDataSource(categories: menuCategories)
            
            let viewModel = categories.compactMap { item in
                CategoryViewModel(item) {
                    self?.cellAction?(item.id)
                }
            }
            
            self?.delegate = MenuDelegate(
                tableView: tableView,
                viewModel: viewModel
            )
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
