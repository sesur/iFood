import UIKit

class MenuViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableview: UITableView!
    
    var cellAction: ((String) -> Void)?
    
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
        loadContent(state: StateController())
    }
    
    private func loadContent(state: StateController) {
        let loadingController = LoadingViewController()
        add(loadingController)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self, tableview] in
            loadingController.remove()
            self?.dataSource = MenuDataSource(menu: state.items.map({ item in
                CategoryViewModel(item) { }
            }))
            
            self?.delegate = MenuDelegate(tableView: tableview, menu: state.items.map({ item in
                CategoryViewModel(item, selection: {
                    self?.cellAction?(item.title.rawValue)
                })
            }))
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
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
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
