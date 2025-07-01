//
//  PhotosDisplayerViewController.swift
//  PhotosDisplayer
//
//  Created by Asaad Jaber on 24/06/2025.
//

import UIKit

class PhotosDisplayerViewController: UIViewController {
    
    @IBOutlet var photosCollectionView: UICollectionView!
    
    var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    enum Section: Int {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosCollectionView.collectionViewLayout = createCompositionalLayout()
        
        createDataSource()
        
        updateInitialSnapshot()
    }
        
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                           heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(1/3))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    // 1. Connect the data source to the collection view, 2. Configure dequeuing the collection view cell.
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: photosCollectionView) { collectionView, indexPath, identifier in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
                    
            cell.backgroundColor = .magenta.withAlphaComponent(0.13)
            
            return cell
        }
    }
    
    func updateInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        
        snapshot.appendSections([.main])
        
        snapshot.appendItems(numbers, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
