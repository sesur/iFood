import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationController = UINavigationController()
        let localLoader = LocalLoader(loader: BundleLoader(),
                                      bundle: BundleResources(fileName: FileName.food,
                                                              fileExtension: FileExtensionType.json))
        
        let service = FoodServiceComposer(remoteLoader: RemoteLoader(),
                                          localLoader: localLoader)

        let state = FoodServiceState(service: service)
        coordinator = MainCoordinator(navigationController: navigationController,
                                      state: state)
        coordinator?.start()
       
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible() 
        
        return true
    }
}
