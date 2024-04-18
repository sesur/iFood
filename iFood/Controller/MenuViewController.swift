import UIKit

class MenuViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableview: UITableView!
    
    var cellAction: ((Int) -> Void)?
    
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
        
        let state = StateController()
        state.loadCategories { [weak self] result in
            switch result {
            case .success(let food):
                self?.food = food
            case .failure(let error):
                print(error)
            }
        }
        
        if let food {
            load(food: food)
        }
    }
    
    private func load(food: Food) {
        let loadingController = LoadingViewController()
        add(loadingController)
        
        updateMenu(
            with: food,
            tableView: self.tableview,
            loadingController: loadingController
        )
    }
    
    private func updateMenu(
        with food: Food,
        tableView: UITableView,
        loadingController: LoadingViewController
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            loadingController.remove()
            
            let categories = food.categories.compactMap { item in
                CategoryViewModel(image: item.imageName,
                                  title: item.title,
                                  select: {  })
            }
            
            self?.dataSource = MenuDataSource(categories: categories)
            
            let viewModel = food.categories.compactMap { item in
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
