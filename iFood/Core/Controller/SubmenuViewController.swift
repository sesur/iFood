import UIKit
import SwiftUI

class SubmenuViewController: UIViewController, Storyboarded {
    
    weak var coordinator: SubmenuCoordinator?
    var items: [RecipeViewModel]?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension SubmenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let viewModel = items?[indexPath.item],
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "submenuCell",
                                                            for: indexPath) as? SubmenuCell
        else {
            return UICollectionViewCell()
        }

        cell.contentConfiguration = UIHostingConfiguration {
            SubmenuView(viewModel: viewModel)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellDimention = (width / 2) - 0
        return CGSize(width: cellDimention, height: cellDimention)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let items = items else { return }
        let item = items[indexPath.item]
        item.select(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

struct ItemView: View {
    var items: [RecipeViewModel]?
    weak var coordinator: SubmenuCoordinator?
    
    var body: some View {
        if let items = items {
            ScrollView {
                LazyHGrid(rows: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(items, id: \.id) { item in
                        ItemDetailsView(viewModel: item)
//                        Text(item.title)
                    }
                    //                    ForEach(items, id: \.title) { element in
                    //                        Text(element.title)
                    //                            .padding()
                    //                            .background(Color.blue)
                    //                            .foregroundColor(.white)
                    //                            .cornerRadius(10)
                    ////                            .onTapGesture {
                    ////                                coordinator?.didSelectItem(element)
                    ////                            }
                    //                    }
                    //                }
                    //                .padding()
                }
            }
        }
    }
}
